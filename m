Return-Path: <linux-kernel-owner+w=401wt.eu-S932162AbXCHR27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbXCHR27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932173AbXCHR27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:28:59 -0500
Received: from mcr-smtp-001.bulldogdsl.com ([212.158.248.7]:1607 "EHLO
	mcr-smtp-001.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932162AbXCHR26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:28:58 -0500
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux v2.6.21-rc3
User-Agent: KMail/1.9.5
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2456
Date: Thu, 8 Mar 2007 17:28:54 +0000
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200703081728.54188.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Dropped LKML, whoops.)

On Wednesday 07 March 2007 04:59, you wrote:
> We've finally hopefully started to put a dent in the regressions,
> especially the suspend/resume problems introduced since 2.6.20.
>
> So 2.6.21-rc3 is out there now, and there's some hope that it will work
> more widely than -rc1 and -rc2 did. Please do give it a good testing, and
> update Adrian and the mailing list (and me) about any regressions
> (hopefully many more of the "it's fixed now" than other kinds, but all
> regressions are interesting).

Robert and Jeff already know about these, but I thought I'd send out a
reminder.

ata2: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 
status 0x500 next cpb count 0x0 next cpb idx 0x0
ata2: CPB 0: ctl_flags 0xd, resp_flags 0x1
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd 35/00:30:b5:c1:8f/00:01:01:00:00/e0 tag 0 cdb 0x0 data 155648 out
         res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: soft resetting port
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: configured for UDMA/133
ata2: EH complete
SCSI device sdb: 488397168 512-byte hdwr sectors (250059 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA

They didn't happen (or didn't happen as frequently) in 2.6.20; it's a serious
bug. Happened in -rc2 and -rc3. A patch from Robert reverting
721449bf0d51213fe3abf0ac3e3561ef9ea7827a seems to make them go away.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
