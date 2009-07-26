Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbZGZC2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbZGZC2B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 22:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZGZC2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 22:28:01 -0400
Received: from ns2.allidaho.com ([66.232.90.194]:42915 "EHLO mail.allidaho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbZGZC2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 22:28:00 -0400
X-Greylist: delayed 2735 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Jul 2009 22:28:00 EDT
From: "Dialup Jon Norstog" <thursday@allidaho.com>
To: Michael Cree <mcree@orcon.net.nz>, Dave Airlie <airlied@gmail.com>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
       xorg@lists.freedesktop.org
Subject: Re: Kernel 2.6.30.1 Oops on Alpha Architecture when starting Xserver
Date: Sat, 25 Jul 2009 19:26:32 -0600
Message-Id: <20090726012112.M10928@allidaho.com>
In-Reply-To: <4A6B9DCB.1090001@orcon.net.nz>
References: <4A5DB243.2000100@orcon.net.nz>	 <21d7e9970907152016u3b213beet9090ee3b34f6d8b1@mail.gmail.com>	 <4A6ACE7C.9090409@orcon.net.nz> <21d7e9970907251554m18e4fca5p69b758e36fddc7d9@mail.gmail.com> <4A6B9DCB.1090001@orcon.net.nz>
X-Mailer: OpenWebMail 2.52 20061019
X-OriginatingIP: 24.116.152.39 (thursday)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My experience:

I have loaded linux on a number of Alphamachines, including the PWS series,
XP100 and UP2000/+.  Sometimes the X-erver doesn't work.  And it trashes the
whole install. Once that happens, you can chaNGE graphics cards but the
X-serve will not recover, maybe because the kernel is implicated in the whole
train wreck.

I usually just wipe everything clean and re-install with a known good graphics
card.

It wasn't a problem back when Compaq was paying Red Hat to put together the
7.1 and 7.2 distros.  There just aren't enough people working on Linux Alpha,
and the whole thing has gotten rickety.  IMHO

jn


---------- Original Message -----------
From: Michael Cree <mcree@orcon.net.nz>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
xorg@lists.freedesktop.org
Sent: Sun, 26 Jul 2009 12:05:31 +1200
Subject: Re: Kernel 2.6.30.1 Oops on Alpha Architecture when starting Xserver

> Dave Airlie wrote:
> >>>> The kernel oops is:
> >>>>
> >>>>         
> >>> So its a machine check,
> >>>
> >>>       
> >> So, does this indicate a software fault (e.g. inconsistencies in kernel data
> >> structures) or does it imply a hardware fault?
> >>
> >>     
> >>> Well X is trying to post the graphics card you have installed, and the
> >>> machine
> >>> is falling over when it does it.
> >>>
> >>>       
> >> SRM (the equivalent of a BIOS) cannot post the card on startup.  But I have
> >> had the card (radeon rv610) post correctly and working in the past when I
> >> compiled the complete 1.5.3 Xserver myself.  I had it working with both the
> >> radeon and radeonhd drivers and a 2.6.29.x kernel patched to support
> >> libpciaccess.
> >>     
> >
> > There is no -ati card in that machine, its got some SiS card which is
> > completely
> > different, maybe its some onboard card or something.
> >
> 
> No, you have misunderstood.   I removed that Radeon rv610 card (that 
> caused the kernel oops) from the machine and replaced it with an old 
> SiS card I have.  The behaviour changed: now the Xserver locks up on 
> initialisation and consumes 100% CPU.  The backtrace I provided is 
> with the SiS card only.  I thought it might be helpful to locate the 
> problem 
> (assuming that we are seeing a different symptom of the same 
> underlying problem).
> 
> BTW, my attempt to CC the xorg mailing list failed.  It would seem 
> that they are too exclusive to allow posting to their email list 
> without subscription.  Putting up such barriers means they won't get 
> bug reports from such people as myself.  Their loss.
> 
> Cheers
> Michael
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> alpha" in the body of a message to majordomo@vger.kernel.org More 
> majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> This message has been scanned for viruses and
> dangerous content by MailScanner, and is
> believed to be clean.
------- End of Original Message -------

