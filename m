Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZBQT3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZBQT3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbZBQT3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:29:42 -0500
Received: from mail-gx0-f163.google.com ([209.85.217.163]:54085 "EHLO
	mail-gx0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbZBQT3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:29:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Yux/QKZHgT6y5QGLB5BSU6ATydk8rBkMclV3TmjAhF4KxtWbGEZZwoHvqY0YaRHJXz
         Y+9MOx8cJl6xYlnOVF2N+UO4QkHdVxV1QvEDQ+8c5iJz6n+uzWE9yeYzk613uF2dRQxM
         FD0OknH7zLdeRpMFniJKNbnXzPdwj6kl9F17c=
Message-ID: <499B0FD7.2050906@gmail.com>
Date: Tue, 17 Feb 2009 14:28:23 -0500
From: David Pflug <dtpflug@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090124)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [BUG] >2.6.27 dies at cardbus init on laptop
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While trying to boot kernels greater than 2.6.27 on this Toshiba
Satellite 1135-S155, it freezes while initializing Texas Instruments
PCI1410 PC card Cardbus Controller [104c:ac50]. However, it boots with
pci=noacpi. The IRQ of the cardbus is shared by one of the USB
controllers and the IDE controller.

Identical symptoms on 2.6.29rc5.

Last few messages with default kernel line:
pci 0000:00:1e.0:   PREFETCH window: 0x00000040000000-0x0000004bffffff
pci 0000:02:02.0: enabling device (0000 -> 0003)
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
pci 0000:02:02.0: PCI INT A -> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11

dmesg with acpi=off:
http://dpaste.com/hold/121766/

Kernel config:
http://dpaste.com/hold/121721/

lspci output:
http://dpaste.com/hold/121768/

Is there anything else I can do to help debug?

--
David Pflug
