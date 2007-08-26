Return-Path: <linux-kernel-owner+w=401wt.eu-S1751907AbXHZH7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbXHZH7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 03:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbXHZH7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 03:59:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:11279 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbXHZH7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 03:59:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:organization:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=BaQXMkOltMqgrrlEva2kkvZ+VhVl93e5yCn8ilLXxaiE5eA2yCqQYnMLixpfTk6Hx/el34lHTJET6snfQrrSC41SsqzQt4kyF9VtRopOJXGZQt4Dwo2USiVMMk1KhCkuwAkcMaO7AioPY5hEOR+ExgEfdN4A5NunlnDTjbv2ddw=
Message-ID: <46D132C5.5000803@gmail.com>
Date: Sun, 26 Aug 2007 09:59:01 +0200
From: Patrizio Bassi <patrizio.bassi@gmail.com>
Reply-To: patrizio.bassi@gmail.com
Organization: patrizio.bassi@gmail.com
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: "Kernel, " <linux-kernel@vger.kernel.org>
Subject: libata not working for sis5533
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My sis630 chipset shipped with Asus A1000
doesn't work properly with suspend with ide drivers
(http://bugzilla.kernel.org/show_bug.cgi?id=7077)

i tried to switch to libata but i cannot boot.
I've enabled generic ide and sis specific code, both in-kernel. of
course scsi too.

when i boot i get: irq #14 nobody cared and stop

i have to remove battery to reboot pc.
I'm using 2.6.22.5, but i never got any libata kernel working.

Patrizio

ps. i'm writing from my desktop as i'm doing hardware mainteinance on
the laptop and could not boot it

Please CC me.

lspci:
00:00.0 Host bridge: Silicon Integrated Systems [SiS] 630 Host (rev 11)
00:00.1 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE] (rev d0)
00:01.0 ISA bridge: Silicon Integrated Systems [SiS] SiS85C503/5513 (LPC
Bridge)
00:01.1 Ethernet controller: Silicon Integrated Systems [SiS] SiS900
PCI Fast Ethernet (rev 80)
00:01.2 USB Controller: Silicon Integrated Systems [SiS] USB  1.0
Controller (rev 07)
00:01.3 USB Controller: Silicon Integrated Systems [SiS] USB 1.0
Controller (rev 07)
00:01.4 Multimedia audio controller: Silicon Integrated Systems [SiS]
SiS PCI Audio Accelerator (rev 01)
 00:01.6 Modem: Silicon Integrated Systems [SiS] AC'97 Modem
Controller (rev a0)
00:02.0 PCI bridge: Silicon Integrated Systems [SiS] Virtual
PCI-to-PCI bridge (AGP)
00:0a.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev 80)
00:0a.1 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev 80)
01:00.0 VGA compatible controller: Silicon Integrated Systems [SiS]
630/730 PCI/AGP VGA Display Adapter (rev 11)
