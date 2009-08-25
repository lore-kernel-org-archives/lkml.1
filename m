Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbZHYPDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbZHYPDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 11:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280AbZHYPDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 11:03:08 -0400
Received: from staff.task.gda.pl ([153.19.250.116]:2340 "EHLO
	staff.task.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbZHYPDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 11:03:07 -0400
Date: Tue, 25 Aug 2009 17:03:04 +0200 (CEST)
From: Pawel Golaszewski <blues@gda.pl>
X-X-Sender: blues@staff.task.gda.pl
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: PROBLEM: oops
In-Reply-To: <1251211483.7538.1162.camel@twins>
Message-ID: <alpine.LNX.2.00.0908251701020.16876@fgnss.gnfx.tqn.cy>
References: <alpine.LNX.2.00.0908251515380.16876@fgnss.gnfx.tqn.cy>  <1251209206.7538.1159.camel@twins>  <alpine.LNX.2.00.0908251608280.16876@fgnss.gnfx.tqn.cy>  <1251209734.7538.1160.camel@twins>  <alpine.LNX.2.00.0908251625580.16876@fgnss.gnfx.tqn.cy>
 <1251211483.7538.1162.camel@twins>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="328824058-1792396283-1251212584=:16876"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--328824058-1792396283-1251212584=:16876
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT

On Tue, 25 Aug 2009, Peter Zijlstra wrote:
> > > > > > No matter which kernel I'm using (2.6.27 - 2.6.30) it crashes. 
> > > > > > Works for few minutes and crashes. Even SysRq doesn't work. Dunno 
> > > > > > how to trigger it on other machine than mine (I have two, both 
> > > > > > affected). If more info is required - just ask.
> > > > > > [...]
> > > > > > [24483.211036] BUG: unable to handle kernel NULL pointer dereference at 00000058
> > > > > > [24483.211144] IP: [<c081cf9a>] pick_next_task_fair+0x6a/0x100
> > > > > > [24483.211247] Oops: 0000 [#1] SMP 
> > > > > > [24483.211300] Modules linked in: netconsole configfs dm_mod softdog sch_sfq xfs raid10 uhci_hcd eepro100 ppdev parport_pc floppy parport ehci_hcd e100 piix i2c_piix4 thermal psmouse e1000 container ide_core usbcore mii button pcspkr serio_raw processor i2c_core sg evdev ext3 jbd mbcache scsi_wait_scan sd_mod crc_t10dif ata_piix libata dock aic7xxx sym53c8xx scsi_transport_spi scsi_mod raid1 md_mod
> > > > > > [24483.211878] 
> > > > > > [24483.211910] Pid: 1677, comm: md2_raid10 Not tainted (2.6.27.31-1 #1)
> > > > > So you're saying .30 crashes at the exact same place?
> > > > Well... I'm not able to catch anything on .30 No sign on 
> > > > netconsole, black screen on monitor...
> > > Could you share your .config?
> > Sure, I forgot: http://www.blues.gda.pl/2.6.27.31.config.bz2
> Right, are you actually using group scheduling?

Not, yet - I wanted to start using it...

> could you try to reproduce without that?
> 
> CONFIG_GROUP_SCHED=n

I'll try. 

Do you think it's source of a problem?

-- 
pozdr.  Pawe³ Go³aszewski          jid:blues<at>jabber<dot>gda<dot>pl
--------------------------------------------------------------------------
If you think of MS-DOS as mono, and Windows as stereo, then Linux is Dolby
Pro-Logic Surround Sound with Bass Boost and all the music is free.
--328824058-1792396283-1251212584=:16876--
