Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbXD2PmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbXD2PmI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 11:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbXD2PmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 11:42:07 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:36633 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504AbXD2PmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 11:42:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I6vJL2b/pd+xRtgj2ofORMOV6JWHImIAh5/bIfDBeNwdSS5Jz9oFLLhcGO70I3p0xFNnO0iIFYjIrrCqtXpK2vMv9Sd+DJbmV2cTwiD8pZqb0cOLGb9SpQb12otEBvG0bhtXXowXjLB2HfO6DHXVbsAvDO53YYxEaCIy6bwubzM=
Message-ID: <2c0942db0704290842j71a5d93cn10f7259559311642@mail.gmail.com>
Date: Sun, 29 Apr 2007 08:42:03 -0700
From: "Ray Lee" <madrabbit@gmail.com>
To: "Kasper Sandberg" <lkml@metanurb.dk>
Subject: Re: [patch] CFS scheduler, -v6
Cc: "Ingo Molnar" <mingo@elte.hu>, "Willy Tarreau" <w@1wt.eu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Gene Heskett" <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       "Con Kolivas" <kernel@kolivas.org>, "Nick Piggin" <npiggin@suse.de>,
       "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Thomas Gleixner" <tglx@linutronix.de>, caglar@pardus.org.tr,
       "Mark Lord" <lkml@rtr.ca>, "Zach Carter" <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
In-Reply-To: <1177833575.9756.22.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070425214704.GA32572@elte.hu>
	 <200704261041.04838.gene.heskett@gmail.com>
	 <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu>
	 <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost>
	 <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu>
	 <20070429065900.GB32281@elte.hu> <1177833575.9756.22.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/07, Kasper Sandberg <lkml@metanurb.dk> wrote:
> On Sun, 2007-04-29 at 08:59 +0200, Ingo Molnar wrote:
> > well, there are several reports of CFS being significantly better than
> > SD on a number of workloads - and i know of only two reports where SD
> > was reported to be better than CFS: in Kasper's test (where i'd like to
> > know what the "3D stuff" he uses is and take a good look at that
> > workload), and another 3D report which was done against -v6. (And even
> > in these two reports the 'smoothness advantage' was not dramatic. If you
> > know of any other reports then please let me know!)
>
> I can tell you one thing, its not just me that has observed the
> smoothness in 3d stuff, after i tried rsdl first i've had lots of people
> try rsdl and subsequently sd because of the significant improvement in
> smoothness, and they have all found the same results.
>
> The stuff i have tested with in particular is unreal tournament 2004 and
> world of warcraft through wine, both running opengl, and consuming all
> the cpu time it can get.

[snip more of sd smoother than cfs report]

WINE is an interesting workload as it does most of its work out of
process to the 'wineserver', which then does more work out of process
to the X server. So, it's three mutually interacting processes total,
once one includes the original client (Unreal Tournament or World of
Warcraft, in this case).

Perhaps running one of the windows system performance apps (that can
be freely downloaded) under WINE would give some hard numbers people
could use to try to reproduce the report.

Ray
