Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbZGGNa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbZGGNa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755878AbZGGNad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:30:33 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:41121 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbZGGNaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:30:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bTdzNvjh6y+5BV1oytlaakW2yhjiltGFGvOKe8bbcIsDgCQIZQXleBORHPsfvqvcQY
         emO2Nft5QcgRL6Pa9uALSVTG+WGdF4Xz3ZKRIP7BFgVrdOED80O+Bf4GhMHuNlYNIVPu
         C85VAGqSPrCTRCOXYD8z3BsT6SMhSMilrM57A=
Date: Tue, 7 Jul 2009 15:29:37 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Andres Freund <andres@anarazel.de>
Cc: Joao Correia <joaomiguelcorreia@gmail.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (
	possibly?caused by netem)
Message-ID: <20090707132937.GA6798@ami.dom.local>
References: <200907031326.21822.andres@anarazel.de> <a5d9929e0907070340y63280508t92e6c7e4ce464994@mail.gmail.com> <20090707131803.GA6520@ami.dom.local> <200907071522.06812.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907071522.06812.andres@anarazel.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 03:22:06PM +0200, Andres Freund wrote:
> On Tuesday 07 July 2009 15:18:03 Jarek Poplawski wrote:
> > On Tue, Jul 07, 2009 at 11:40:16AM +0100, Joao Correia wrote:
> > > I am now running 2.6.31-rc2 for a couple of hours, no freeze.
> > > Let me know what/if i can help with tracking down the original source
> > > of the problem.
> > OK, so we know it's only about timers. Here is another tiny patch
> > (the previous one should be removed), which could tell (with oops) if
> > there's something while migrating. Anyway, the bug should be back :-(
> How do we know this? It still could be a race uncovered by timer migration, 
> right?

Right. But (rather) not by or in hrtimers.

> PS: You forgot the patch ;-)

Yes, I hope you got it already ;-)

Thanks,
Jarek P.
