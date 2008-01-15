Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbYAOKNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbYAOKNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYAOKMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:12:48 -0500
Received: from [211.102.241.196] ([211.102.241.196]:33087 "EHLO mail.yuvad.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbYAOKMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:12:47 -0500
From: "Mao Rui" <maorui@yuvad.com>
To: <linux-kernel@vger.kernel.org>
Subject: SATA DOM is not identified by ata_piix module
Date: Tue, 15 Jan 2008 18:11:25 +0800
Message-ID: <003a01c8575f$070d2230$7740a8c0@cmaorui2>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: AchXXM8AqKPptE8ET1SkVWZpfV69DA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a PQI Turbo SATA DOM. It works well under Windows. I installed it in
a SuperMicro motherboard, Intel 5000P chipset. The OS is Ubuntu 7.04, kernel
2.6.20-15. But the DOM is not appeared as a device node, and I found several
error messages in kernel log.

[   67.124299] ata2.00: qc timeout (cmd 0x91)
[   67.124306] ata2.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
err_mask=0x4)
[   67.124309] ata2: failed to recover some devices, retrying in 5 secs
[  102.258334] ata2.00: qc timeout (cmd 0x91)
[  102.258341] ata2.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
err_mask=0x4)
[  102.258344] ata2: failed to recover some devices, retrying in 5 secs
[  137.392654] ata2.00: qc timeout (cmd 0x91)
[  137.392661] ata2.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
err_mask=0x4)

Actually I also have a PQI IDE DOM, it have same error with Ubuntu 7.04 /
kernel 2.6.20-15. After I upgrade kernel to 2.6.22, the IDE DOM can work.
But as for SATA DOM, I have no luck this time. Even with the newest kernel,
2.6.23.14 and 2.6.24-rc7-git6, the problem still exists.
I also found an interesting matter. The Ubuntu 6.10, say kernel 2.6.15-28,
can identify both IDE DOM and SATA DOM. But due to other critical problem, I
can not go back to this old kernel.

What’s going on? The new kernel is even worse than old one. It seems the
problem is existing in the ata_piix driver.

Best regards,
Mao Rui



