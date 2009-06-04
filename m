Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbZFDJKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbZFDJKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 05:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbZFDJKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 05:10:03 -0400
Received: from comar.pardus.org.tr ([193.140.100.220]:39676 "EHLO
	pardus.org.tr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752091AbZFDJKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 05:10:01 -0400
Message-ID: <4A278FEC.3000805@pardus.org.tr>
Date: Thu, 04 Jun 2009 12:12:12 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.21 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>, alan@lxorguk.ukuu.org.uk
Subject: [BUG] Loading parport_pc kills the keyboard if ACPI is enabled
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was having this issue since 2.6.30_rc1 (if I remember correctly) but I
didn't have time to analyze and report here until today.

If I don't give acpi=off during boot, the keyboard becomes unusable when
udev starts. The connection type of the keyboard don't matter at all, I
tried with a USB and a PS/2 one.

I was using the system with acpi=off, today I've booted into initramfs
and loaded all the modules that seem to be loaded after a normal startup.

I inserted parport.ko and then parport_pc.ko and the keyboard is gone,
here are the last lines:

# insmod newroot/lib/modules/2.6.30_rc8-120/kernel/drivers/parport.ko
# insmod newroot/lib/modules/2.6.30_rc8-120/kernel/drivers/parport_pc.ko
parport_pc 00:09: reported by Plug and Play ACPI
parport0: PC-Style at 0x378, irq 7 [PCSPP, TRISTATE]
#


Thanks,
Ozan Caglayan
