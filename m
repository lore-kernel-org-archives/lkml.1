Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbZIXHus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbZIXHus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 03:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbZIXHup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 03:50:45 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:7582 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbZIXHuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 03:50:44 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH v2 0/2] cpu: pseries: Offline state framework.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
In-Reply-To: <1253753307.7103.356.camel@pasglop>
References: <20090828095741.10641.32053.stgit@sofia.in.ibm.com>
	 <1251869611.7547.38.camel@twins>  <1253753307.7103.356.camel@pasglop>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 09:51:07 +0200
Message-Id: <1253778667.7695.130.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 10:48 +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2009-09-02 at 07:33 +0200, Peter Zijlstra wrote:
> > 
> > I'm still thinking this is a bad idea.
> > 
> > The OS should only know about online/offline.
> > 
> > Use the hypervisor interface to deal with the cpu once its offline.
> > 
> > That is, I think this interface you propose is a layering violation.
> > 
> I don't quite follow your logic here. This is useful for more than just
> hypervisors. For example, take the HV out of the picture for a moment
> and imagine that the HW has the ability to offline CPU in various power
> levels, with varying latencies to bring them back.

cpu-hotplug is an utter slow path, anybody saying latency and hotplug in
the same sentence doesn't seem to grasp either or both concepts.



