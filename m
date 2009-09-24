Return-Path: <linux-kernel-owner+w=401wt.eu-S1752717AbZIXIkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbZIXIkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 04:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZIXIkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 04:40:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:50034 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbZIXIkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 04:40:46 -0400
Subject: Re: [PATCH v2 0/2] cpu: pseries: Offline state framework.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
In-Reply-To: <1253778667.7695.130.camel@twins>
References: <20090828095741.10641.32053.stgit@sofia.in.ibm.com>
	 <1251869611.7547.38.camel@twins>  <1253753307.7103.356.camel@pasglop>
	 <1253778667.7695.130.camel@twins>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 18:38:27 +1000
Message-Id: <1253781508.7103.437.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 09:51 +0200, Peter Zijlstra wrote:
> > I don't quite follow your logic here. This is useful for more than just
> > hypervisors. For example, take the HV out of the picture for a moment
> > and imagine that the HW has the ability to offline CPU in various power
> > levels, with varying latencies to bring them back.
> 
> cpu-hotplug is an utter slow path, anybody saying latency and hotplug in
> the same sentence doesn't seem to grasp either or both concepts.

Let's forget about latency then. Let's imagine I want to set a CPU
offline to save power, vs. setting it offline -and- opening the back
door of the machine to actually physically replace it :-)

In any case, I don't see the added feature as being problematic, and
not such a "layering violation" as you seem to imply it is. It's a
convenient way to atomically take the CPU out -and- convey some
information about the "intent" to the hypervisor, and I really fail
to see why you have so strong objections about it.

Ben.


