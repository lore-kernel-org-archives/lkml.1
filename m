Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbXJ2NFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbXJ2NFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbXJ2NFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:05:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:48215 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbXJ2NFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=iJkvDN78T5/lFjKA3NKx+K+ONBkIhwjcvvYDJfDNfCZENMrsmWB6nUifffebGripiilvWepsvjymZZ1a/xVzx+rH3u/menLVfYEEfI96gHaqYzx7TIeG8C45WZGDq1WqfM7LYYIp8AQKGUljrlgpfkhkKddcfpuKkKypP0o6PvE=
Message-ID: <b3790d380710290605g5d1770fao675418f062f111b9@mail.gmail.com>
Date: Mon, 29 Oct 2007 14:05:44 +0100
From: "Wijnand Rietman" <wijnand.rietman@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: CONFIG_IDEDMA_AUTO & 2.4.32 & hdparm -d1
Cc: wijnand.rietman@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am running Linux on a PC104 board from a compact flash card. Because
the physical DMA lines are missing on some of the compact flash
carrier cards, I would like to be able to boot with DMA disabled and
to enable DMA in a later stage if desired (and supported by hardware).

The problem is that when I set CONFIG_IDEDMA_AUTO to FALSE, I cannot
enable DMA anymore with hdparm, not even with hardware that supports
DMA. If I set CONFIG_IDEDMA_AUTO to TRUE, I can use hdparm to disable
and enable DMA (but of course I get long timeouts with the carrier
cards that do not have the physical DMA lines).

Q1: Is this how the CONFIG_IDEDMA_AUTO setting is supposed to work in
combination with hdparm?
Q2: Is there a way to boot with DMA disabled and to enable it later on
once the system is up and running?

Kernel: 2.4.32
Chipset: CS5530

Any help is highly appreciated!

Regards,
Whinyan
