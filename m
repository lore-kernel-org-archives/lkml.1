Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYAXBPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYAXBPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 20:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbYAXBPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 20:15:47 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:9286 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbYAXBPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 20:15:46 -0500
To: Tobias Winter <tobias@linuxdingsda.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel bug report 2.6.24-rc8 on core2quad q6600 with debian unstable amd64
X-Message-Flag: Warning: May contain useful information
References: <4797D86B.3060202@linuxdingsda.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 23 Jan 2008 17:15:44 -0800
In-Reply-To: <4797D86B.3060202@linuxdingsda.de> (Tobias Winter's message of "Thu, 24 Jan 2008 01:14:35 +0100")
Message-ID: <adaabmwowfz.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Jan 2008 01:15:44.0572 (UTC) FILETIME=[A4BDA7C0:01C85E26]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > drivers/acpi/pci_bind.c: In function 'acpi_pci_unbind':<built-in>:0:
 > internal compiler error: Segmentation fault
 > Depending on which kernel i build, it fails on different things.

Seems like a classic symptom of some sort of hardware fault/memory corruption...

 > I tried disabling HPET and VT in the BIOS but that didn't help. I also
 > ruled out any memory problems with memtest86+.Don't know what else to do.

So your memory may be OK... (memtest86 does miss some problem sometimes)

 > [8.6.] SCSI information (from /proc/scsi/scsi)
 > Attached devices:
 > Host: scsi0 Channel: 00 Id: 01 Lun: 00
 >   Vendor: IBM-PCCO Model: DDRS-34560W   !# Rev: S97B
 >   Type:   Direct-Access                    ANSI  SCSI revision: 02
 > Host: scsi0 Channel: 00 Id: 05 Lun: 00
 >   Vendor: NEC      Model: CD-ROM DRIVE:464 Rev: 1.14
 >   Type:   CD-ROM                           ANSI  SCSI revision: 02
 > Host: scsi1 Channel: 00 Id: 00 Lun: 00
 >   Vendor: ATA      Model: Maxtor 6V250F0   Rev: VA11
 >   Type:   Direct-Access                    ANSI  SCSI revision: 05
 > Host: scsi2 Channel: 00 Id: 00 Lun: 00
 >   Vendor: ATA      Model: Maxtor 6V250F0   Rev: VA11
 >   Type:   Direct-Access                    ANSI  SCSI revision: 05
 > Host: scsi3 Channel: 00 Id: 00 Lun: 00
 >   Vendor: ATA      Model: Maxtor 6V250F0   Rev: VA11
 >   Type:   Direct-Access                    ANSI  SCSI revision: 05
 > Host: scsi4 Channel: 00 Id: 00 Lun: 00
 >   Vendor: ATA      Model: Maxtor 6V250F0   Rev: VA11
 >   Type:   Direct-Access                    ANSI  SCSI revision: 05
 > Host: scsi5 Channel: 00 Id: 00 Lun: 00
 >   Vendor: ATA      Model: Maxtor 6V250F0   Rev: VA11
 >   Type:   Direct-Access                    ANSI  SCSI revision: 05
 > Host: scsi6 Channel: 00 Id: 00 Lun: 00
 >   Vendor: ATA      Model: Maxtor 6V250F0   Rev: VA11
 >   Type:   Direct-Access                    ANSI  SCSI revision: 05
 > Host: scsi7 Channel: 00 Id: 00 Lun: 00
 >   Vendor: ATA      Model: Maxtor 6L250R0   Rev: BAJ4
 >   Type:   Direct-Access                    ANSI  SCSI revision: 05
 > Host: scsi7 Channel: 00 Id: 01 Lun: 00
 >   Vendor: ATA      Model: Maxtor 6L250R0   Rev: BAH4
 >   Type:   Direct-Access                    ANSI  SCSI revision: 05

That is a lot of hard drives... my guess would be that your power
supply is marginal, a cable/adapter card isn't seated perfectly
somewhere, something is overheating, or something like that.
