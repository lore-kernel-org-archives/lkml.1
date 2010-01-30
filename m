Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037Ab0A3SgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab0A3SgO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 13:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543Ab0A3SgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 13:36:14 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:51193 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab0A3SgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 13:36:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=cgzSNVDx/rugbO2eHhA9EhNGyd6JyOp1eaKyWgMKMo/ErKaSafQNq035e8lKLn6ntU
         0hVkhgXYMxCfV0XQ1rHmmA6n0mpuRFqUKdrMG9OzzpF9ZQIA+0fXtwF85d3KMPVtGaaC
         nznrlOk1NxiKFmM28A2V0+dE388ORpyvY2Zqg=
MIME-Version: 1.0
Date: Sun, 31 Jan 2010 00:06:12 +0530
Message-ID: <b2ac5deb1001301036l4bf7550ck3fdfcc31c8467aca@mail.gmail.com>
Subject: Setting of PE bit reboots the system
From: Swapnil Pimpale <swapnil.pict@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am working on Intel Core 2 Duo architecture. As a part of my
academic project, I need to bring up the second core from the
bootloader (GRUB).
When the second core comes up, I need to switch it from real mode to
protected mode.
For this, I am trying to set the PE bit of cr0 register. But, whenever
I set the PE bit the system reboots.
For switching from real to protected mode I use the following steps:
1) Clear Interrupts
2) Load GDT
3) Set PE bit of cr0
4) Long Jump to Protected mode code

Is there any thing that I am missing? Should the gate A20 line be
turned on from the second core also?
Is there any solution on the problem of setting PE bit?

Thanks,
Swapnil Pimpale.
