Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbXDFADV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbXDFADV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 20:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbXDFADV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 20:03:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42664 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbXDFADT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 20:03:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.21-rc5 possible regression: KDE processes die silently (was: 2.6.21-rc3-mm2: KDE processes die while system is idle)
Date: Fri, 6 Apr 2007 02:06:58 +0200
User-Agent: KMail/1.9.5
Cc: Tilman Schmidt <tilman@imap.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4601B3D0.3060600@imap.cc> <200704011848.03971.rjw@sisk.pl> <20070402230640.GJ14134@stusta.de>
In-Reply-To: <20070402230640.GJ14134@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704060206.59187.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 April 2007 01:06, Adrian Bunk wrote:
> On Sun, Apr 01, 2007 at 06:48:03PM +0200, Rafael J. Wysocki wrote:
> > On Sunday, 1 April 2007 17:21, Tilman Schmidt wrote:
> > > I'm sorry to say this has now happened with kernel 2.6.21-rc5, too.
> > > I started a kernel compilation in the evening and came back in the
> > > morning to find all KDE decorations gone. All processes normally
> > > running for a KDE session and labelled "[kinit]" in ps were gone
> > > but everything else was running fine, and the system was still
> > > usable via ssh. /var/log/kdm.log and /var/log/Xorg.0.log contained
> > > nothing remotely suspicious. /var/log/messages had two lines I
> > > never saw before:
> > > 
> > > Mar 31 02:27:36 gx110 kernel: [153577.891443] ReiserFS: hda3: warning: vs-8115: get_num_ver: not directory or indirect item
> > > Mar 31 02:27:36 gx110 kernel: [153577.891559] ReiserFS: hda3: warning: vs-8115: get_num_ver: not directory or indirect item
> > > 
> > > But those didn't appear on previous occurrences of the "dying KDE"
> > > problem so I guess they are not related.
> > > 
> > > This is SUSE LINUX 10.0 (i586) running on a Dell OptiPlex GX110
> > > (Intel P3, 933 MHz, i810 chipset, 512 MB RAM, 60 GB ATA disk)
> > > % uname -a
> > > Linux gx110 2.6.21-rc5-noinitrd #1 PREEMPT Sat Mar 31 02:15:19 CEST 2007 i686 i686 i386 GNU/Linux
> > > % cat /proc/cmdline
> > > root=/dev/hda3 selinux=0 x11i=vesa video=intelfb:mode=1280x1024-32@70 nmi_watchdog=2 lapic 5
> > > Kernel configuration mostly-modular, based on standard SuSE kernel's
> > > /proc/config.gz, just compiling into the kernel everything I need to
> > > boot without an initrd and omitting some parts I'm not interested in.
> > > (.config attached.) What else might be relevant?
> > > 
> > > Again, this is a Heisenbug, ie. it's not reproducible and invariably
> > > happens when I'm away from the machine. (Probably Murphy at work.)
> > > It's pretty rare: I have seen it four times on 2.6.21-rc3-mm2 and
> > > once on 2.6.21-rc5, on a machine which spends about equal amounts
> > > of time running the latest stable, rc, and mm kernels. OTOH, so far
> > > it hasn't ever happened with any 2.6.20 or earlier kernel. Nor have
> > > I seen it with 2.6.21-rc[1-4] or 2.6.21-rc4-mm* - but for the -rc4
> > > and -rc4-mm releases that's not conclusive as those have only been
> > > running for a very short time.
> > 
> > I have a similar problem on x86_64 OpenSUSE 10.2, but it seems to happen
> > when a sound (eg. notification) is played while the display is suspended
> > (or "powered off").
> 
> Is it easily reproducible and still present with the latest -git?
> If yes, can you bisect?
> 
> > IMO it's a SUSE bug.
> 
> We also have a report of KDE crashes on Debian [1].
> And just a few days ago a kernel bug kwin ran into was fixed [2].
> 
> If the pattern is "works with 2.6.20 but does not work with 2.6.21-rc",
> then it's most likely a kernel regression.

Well, I'm not able to reproduce it with the current mainline, so let's hope
it's been fixed. :-)

Greetings,
Rafael
