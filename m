Return-Path: <linux-kernel-owner+w=401wt.eu-S936352AbZLQENC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936352AbZLQENC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:13:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936328AbZLQEMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:12:19 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:50655 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936185AbZLQEMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:12:13 -0500
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_aCfPdIXrbBwYqCwnDUWBLQ)"
Date: Wed, 16 Dec 2009 23:12:10 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: =?ISO-8859-15?Q?Malte_Schr=F6der?= <maltesch@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [REGRESSION] System wakeup by time not working anymore on 2.6.32
In-reply-to: <20091203190610.1af77642@highlander.home.lan>
Message-id: <alpine.LFD.2.00.0912162311270.10371@localhost.localdomain>
References: <20091203190610.1af77642@highlander.home.lan>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_aCfPdIXrbBwYqCwnDUWBLQ)
Content-type: TEXT/PLAIN; charset=UTF-8
Content-transfer-encoding: 8BIT

On Thu, 3 Dec 2009, Malte Schröder wrote:

> Hello,
> I have a PC which I use as a harddisk videorecorder.
> If unused it is powered down, so I put the time it is supposed to wake
> up for the next recording into /sys/class/rtc/rtc0/wakealarm.
> This has been working fine for some time.
> After the upgrade to kernel 2.6.32 this stopped working, it doesn't
> wake up, though "cat /proc/driver/rtc" shows the correct data, like
> this:
> 
> rtc_time	: 18:02:20
> rtc_date	: 2009-12-03
> alrm_time	: 18:05:38
> alrm_date	: 2009-12-03
> alarm_IRQ	: yes
> alrm_pending	: no
> 24hr		: yes
> periodic_IRQ	: no
> update_IRQ	: no
> HPET_emulated	: yes
> DST_enable	: no
> periodic_freq	: 1024
> batt_status	: okay
> 
> Any ideas?

offhand, no.
Is it possible to bisect?

thanks,
Len Brown, Intel Open Source Technology Center

--Boundary_(ID_aCfPdIXrbBwYqCwnDUWBLQ)--
