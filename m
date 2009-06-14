Return-Path: <linux-kernel-owner+w=401wt.eu-S1762521AbZFNQtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762521AbZFNQtY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 12:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbZFNQtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 12:49:17 -0400
Received: from mx.treblig.org ([80.68.94.177]:36967 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbZFNQtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 12:49:16 -0400
Date: Sun, 14 Jun 2009 18:49:13 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Ozan ?a??layan <ozan@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.{28,30} Keyboard not working on oldish machine
Message-ID: <20090614174913.GC1499@gallifrey>
References: <20090613230842.GA18347@gallifrey> <4A342E1F.60607@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A342E1F.60607@pardus.org.tr>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.29.2-bytemark-kvm-tickless-2009-05-05 (i686)
X-Uptime: 18:48:22 up 19 days, 11:10,  2 users,  load average: 0.01, 0.02, 0.00
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ozan ?a??layan (ozan@pardus.org.tr) wrote:
> Dr. David Alan Gilbert wrote:
> > Hi,
> >   I've got an old Pentium 90 machine that's been running a 2.4.x
> > kernel for a long time, seems to work OK on a 2.6.18 kernel
> > but doesn't seem to like anything newer.
> >
> > 2.6.30 no keyboard - but otherwise OK
> > 2.6.28 no keyboard - but otherwise OK
> > 2.6.26 reboots just after parsing ELF (maybe one more line)
> > 2.6.25 reboots almost immediately
> > 2.6.18 works OK
> >   
> 
> I'm having that weird problem on one of my computers too, I've reported
> it here but then I started to blame my mainboard and BIOS because I
> can't even boot into 2.6.25 which I was using months ago without an
> issue. My keyboard stops working just after the parport* modules are
> plugged. I really wonder what will happen if you blacklist lp, ppdev,
> parport and parport_pc modules.

Thanks for the suggestion Ozan; unfortunately removing all parallel stuff
didn't help.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
