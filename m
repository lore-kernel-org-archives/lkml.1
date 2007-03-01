Return-Path: <linux-kernel-owner+w=401wt.eu-S965058AbXCANkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965058AbXCANkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 08:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965060AbXCANkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 08:40:05 -0500
Received: from mcr-smtp-002.bulldogdsl.com ([212.158.248.8]:2816 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965058AbXCANkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 08:40:03 -0500
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Robert Hancock <hancockr@shaw.ca>
Subject: CK804 SATA Errors (still got them)
Date: Thu, 1 Mar 2007 13:39:52 +0000
User-Agent: KMail/1.9.5
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703011339.52895.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

Despite all the work that went into making these less frequent with ADMA,
they're still possible to trigger.

alistair@damocles:~$ cat /proc/version
Linux version 2.6.21-rc2-damocles (root@damocles) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Wed Feb 28 21:58:41 GMT 2007

alistair@damocles:~$ dmesg | tail -n 13
ata1: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 status 0x500 next cpb count 0x0 next cpb idx 0x0
ata1: CPB 0: ctl_flags 0xd, resp_flags 0x1
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd ca/00:38:ae:08:c2/00:00:00:00:00/e0 tag 0 cdb 0x0 data 28672 out
         res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: soft resetting port
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: configured for UDMA/133
ata1: EH complete
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA

These cause the same ~30 second stalls. Machine was not under load.

No 3rd party modules were loaded.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
