Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbZJBUBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbZJBUBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 16:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757183AbZJBUBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 16:01:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:10616 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221AbZJBUBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 16:01:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jHvFBDvmMWFAtVjOv1nllOGVftyOzr1D8KZD1k7LVYGbDBUMlaPe0ISSRlSmWFZwqW
         wN6PZvYYILBiUYhj4wzhIkbQkyrWlbhOMtMEr8Z/aa/Pxm3jEMrJ1K1xJb/IGg3SgihO
         1SCpwr50BfcQxVjEg52BFhtlezR+vd0g4b+BI=
Date: Fri, 2 Oct 2009 22:01:43 +0200
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Message-ID: <20091002200143.GA3845@bizet.domek.prywatny>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.k2B.ZNTxKB@chimera> <200910021111.55749.elendil@planet.nl> <20091002093226.GJ21906@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002093226.GJ21906@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 10:32:26AM +0100, Mel Gorman wrote:
> On Fri, Oct 02, 2009 at 11:11:52AM +0200, Frans Pop wrote:
> > My own feeling is that Bartlomiej is correct and that something has changed 
> > since .29 and that on average we do have less higher order areas available 
> > after the system has been in use for some time, but I can't substantiate 
> > that. I do know that before .30 I had never seen the SKB allocation 
> > errors.
> > 
> > Main problem is that it's hard to deliberately and reproducibly get the 
> > system in a state where the errors occur.
> > 
> 
> Apparently, Karol Lewandowski (cc added) has a reliable
> reproduction case for when the firmware loading problem occurs
> (http://lkml.org/lkml/2009/9/30/242). While it's not the same problem exactly,
> it's probable they're related. I'm hoping the problem commit can be identified
> by his bisection whenever he gets around to it.

Unfortunately, I've had little success with bisecting this problem.
I've spend fair amount of time today trying to reproduce this problem,
but I'm unable to do so even on kernels that failed "easily" before.

Nothing has changed in hardware/software.  I've changed methodology
somewhat from suspend-and-look-for-failure-on-resume to rmmod, fill
memory, modprobe-and-see-it-fail... but well, few days ago it failed
in either case.

Damn.
