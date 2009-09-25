Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbZIYHm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbZIYHm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 03:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbZIYHm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 03:42:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:57381 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbZIYHmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 03:42:25 -0400
Date: Fri, 25 Sep 2009 09:42:27 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: svaidy@linux.vnet.ibm.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v2 0/2] cpu: pseries: Offline state framework.
Message-ID: <20090925094227.05984cab@infradead.org>
In-Reply-To: <20090925072549.GB9562@dirshya.in.ibm.com>
References: <20090828095741.10641.32053.stgit@sofia.in.ibm.com>
	<1251869611.7547.38.camel@twins>
	<1253753307.7103.356.camel@pasglop>
	<1253778667.7695.130.camel@twins>
	<1253781508.7103.437.camel@pasglop>
	<1253791987.7695.153.camel@twins>
	<20090924134123.4acd1adf@infradead.org>
	<20090925072549.GB9562@dirshya.in.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Sep 2009 12:55:49 +0530
Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> > I obviously can't speak for p-series cpus, just wanted to point out
> > that there is no universal truth about "offlining saves power".
> 
> Hi Arjan,
> 
> As you have said, on some cpus the extra effort of offlining does not
> save us any extra power, and the state will be same as idle.  The
> assertion that offlining saves power is still valid, it could be same
> as idle or better depending on the architecture and implementation.
> 
> On x86 we still need the code (Venki posted) to take cpus to C6 on
> offline to save power or else offlining consumes more power than idle
> due to C1/hlt state.  This framework can help here as well if we have
> any apprehension on making lowest sleep state as default on x86 and
> want the administrator to decide.

even with Venki's patch, all our measurements indicate that taking
cores away is damage on x86. Don't let that stop what you do for
powerpc, but for x86 it's not a win. Linux is good at keeping cores in
C6 long enough that the downside of offlining is bigger...



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
