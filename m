Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbYKPTYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbYKPTYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 14:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbYKPTX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 14:23:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43313 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbYKPTX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 14:23:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.28-rc5: Reported regressions from 2.6.27
Date: Sun, 16 Nov 2008 20:28:33 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera> <alpine.LFD.2.00.0811161030070.3468@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0811161030070.3468@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811162028.34099.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 16 of November 2008, Linus Torvalds wrote:
> 
> On Sun, 16 Nov 2008, Rafael J. Wysocki wrote:
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12049
> > Subject		: Oops in acpi_system_wakeup_device_seq_show
> > Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
> > Date		: 2008-11-16 13:04 (1 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0794469da3f7b2093575cbdfc1108308dd3641ce
> > References	: http://marc.info/?l=linux-kernel&m=122684070215520&w=4
> 
> This already got fixed: commit 77fb61a04a0483ad274ce5c51b02c46c12db3693.
> 
> > Regressions with patches
> > ------------------------
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12042
> > Subject		: USB hid blocks USB port in 2.6.28rc3
> > Submitter	: Andi Kleen <andi@firstfloor.org>
> > Date		: 2008-11-11 0:31 (6 days old)
> > References	: http://marc.info/?l=linux-usb&m=122636246522848&w=4
> > Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> > 		  Jiri Slaby <jirislaby@gmail.com>
> > Patch		: http://marc.info/?l=linux-kernel&m=122661425620251&w=2
> 
> commit 131d3a7a009d56a96cc7117b4e9d0c90c2e2a1dc
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11954
> > Subject		: sysprof tracer ABI regression in 2.6.28rc1
> > Submitter	: Eric Anholt <eric@anholt.net>
> > Date		: 2008-11-04 22:14 (13 days old)
> > Handled-By	: Eric Anholt <eric@anholt.net>
> > Patch		: http://bugzilla.kernel.org/attachment.cgi?id=18683&action=view
> 
> commit 072ba49838b42c873c496d72c91bb237914cf3b6
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11911
> > Subject		: new PCMCIA device instance after resume - orinoco can't download firmware
> > Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
> > Date		: 2008-10-28 19:19 (20 days old)
> > References	: http://marc.info/?l=linux-wireless&m=122522165719760&w=4
> > Handled-By	: Dave <kilroyd@googlemail.com>
> > Patch		: http://marc.info/?l=linux-wireless&m=122539058601588&w=4
> 
> commit e689597fe890cf22e23195037aa668c39b25ae4b

Thanks a lot, closed all of them.

Best,
Rafael
