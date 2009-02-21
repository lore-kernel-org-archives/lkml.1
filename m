Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbZBUNoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbZBUNoV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 08:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbZBUNoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 08:44:14 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:35925 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbZBUNoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 08:44:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=ThibGoqqD6yC18R2Ygx2MKtO90jumHbFGq826PNpm3j4HzyFSmgaIyNy/tYotPVqew
         TRausH6c0fZ303C91heFJZqn3VWyaJ/bhn4wkCBROeN/FY3FGctsriKjVwbSlt3OpvTM
         vCRgS6EM8g6X9LQQNtj3RSdFCegJiZAl07Rhk=
Message-ID: <49A0053F.2050109@gmail.com>
Date: Sat, 21 Feb 2009 15:44:31 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: i915: drm:i915_wait_irq EBUSY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I recently changed AccelMethod to XAA in my xorg.conf, and after
resuming (from hibernate), my X-server crashed with the following dmesg.
It was non-fatal, as I could restart X (from a black console screen -
not sure if that is related). Never had any problems suspending to
either disk/memory without this option up to now...
 
dmesg output:
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0
succeeded                                                             
ata2.00: ACPI cmd e3/00:02:00:00:00:a0
succeeded                                                             
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0
succeeded                                                             
ata2.00: ACPI cmd e3/00:02:00:00:00:a0
succeeded                                                             
ata2.00: configured for
UDMA/133                                                                             

Restarting tasks ...
done.                                                                                   

ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9
t4                                                   
ata2: irq_stat
0x40000001                                                                                    

ata2.00: configured for
UDMA/133                                                                             

ata2: EH
complete                                                                                            

[drm:i915_wait_irq] *ERROR* EBUSY -- rec: 44209483 emitted:
44209484                                         
[drm:i915_wait_irq] *ERROR* EBUSY -- rec: 44209483 emitted:
44209484                                         
[drm:i915_wait_irq] *ERROR* EBUSY -- rec: 44209483 emitted:
44209484                                         
[drm:i915_wait_irq] *ERROR* EBUSY -- rec: 44209483 emitted:
44209484                                         
[drm:i915_wait_irq] *ERROR* EBUSY -- rec: 44209483 emitted: 44209484

The problem occurred on my Thinkpad W500, running OpenSUSE 11.1 with
vanilla 2.6.28.6-pae kernel, using the integrated Intel Mobile GM45
Express chipset.

Any ideas?

Niel

