Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbZFPIse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbZFPIse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbZFPIs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:48:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096AbZFPIs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:48:26 -0400
Date: Tue, 16 Jun 2009 10:48:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Bringer Didier <dda@awalis.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: keyboard problems on HP Pavilion ZE4200
In-Reply-To: <2558ACFA-84E2-4948-B371-D4F9606C0B15@awalis.com>
Message-ID: <alpine.LNX.2.00.0906161044590.7457@wotan.suse.de>
References: <3277220fa08b0d9b83dd7598e6f360d5@192.168.1.20> <20090609200202.GC1388@ucw.cz> <alpine.LNX.2.00.0906100046410.7457@wotan.suse.de> <2558ACFA-84E2-4948-B371-D4F9606C0B15@awalis.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ restored CC list ]

On Thu, 11 Jun 2009, Bringer Didier wrote:

> > > >Under linux (ubuntu 9) some keys are "pressed" even when I'm not
> > > >touching the keyboard, so for example it launches the tool for the
> > > >printscreen hundreds of times and then the machine is not usable
> > > >anymore...
> > >Which kernel? Does it happen on 2.6.30? Does it happen on console?
> > >Which keys?
> >
> >Also output of 'evtest' on the corresponding device in /dev/input/event?
> >from the time the key(s) get stuck will be helpful.
> >
> >Is the keyboard in question PS2-conntected or USB-connected?
> First of all, thank you for your answer
> 
> Kernel : Linux champ 2.6.28-11-generic #42-Ubuntu SMP Fri Apr 17 01:57:59 UTC
> 2009 i686 GNU/Linux
> 
> Output of evtest /dev/input/event4 while the bug appears

> Event: time 1244751563.258790, -------------- Report Sync ------------
>Event: time 1244751563.349861, type 4 (Misc), code 4 (ScanCode), value 54
> Event: time 1244751563.349897, type 1 (Key), code 99 (SysRq), value 1
> Event: time 1244751563.349900, -------------- Report Sync ------------
> Event: time 1244751563.370076, type 4 (Misc), code 4 (ScanCode), value 38
> Event: time 1244751563.370107, type 1 (Key), code 56 (LeftAlt), value 0
> Event: time 1244751563.370109, -------------- Report Sync ------------
> Event: time 1244751563.401550, type 4 (Misc), code 4 (ScanCode), value 0f
> Event: time 1244751563.401583, type 1 (Key), code 15 (Tab), value 0
> Event: time 1244751563.401586, -------------- Report Sync ------------
> Event: time 1244751563.599697, type 4 (Misc), code 4 (ScanCode), value 54
> Event: time 1244751563.599731, type 1 (Key), code 99 (SysRq), value 2

So forever-repeating sysrq/printscreen is really coming out of the evdev 
input node.

Could you please boot you kernel with i8042.debug kernel parameter and 
send the output from the time the bug triggers? This way we'll see whether 
the repeated key really arrives from PS/2.

> I will try with a 2.6.30 soon

Do you know about any kernel version where this bug didn't trigger?

> Weirdly the bug doesn't seem to work when I use KDE as windowsmanager... 
> Under gnome it is every 20 seconds that it happens. I cannot say that 
> the bug really doesn't appear under kde but I cannot see effects of it

You can check the evtest output when running KDE, if the repeated key 
appears there as well.

-- 
Jiri Kosina
SUSE Labs
