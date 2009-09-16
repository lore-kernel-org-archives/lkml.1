Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbZIPHLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbZIPHLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 03:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756901AbZIPHLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 03:11:12 -0400
Received: from tur.go2.pl ([193.17.41.50]:54848 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594AbZIPHLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 03:11:11 -0400
From: Michal Witkowski <neuro@o2.pl>
To: linux-kernel@vger.kernel.org
Subject: Explicitly putting a PCI device to ACPI D0
Date: Wed, 16 Sep 2009 09:10:24 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.30-ARCH; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200909160910.24329.neuro@o2.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been searching for my answer for a while now, and since I haven't found it anywhere, 
I've decided to post to LKML, hoping that someone here can help me.

First, I'll explain the background of my problem. My grief is the switchable GPU in my 
Lenovo Ideapad U330. The BIOS supports two options "Discrete only" (only the ATI card is 
visible on the BUS) and "Switchable" (both ATI and Intel card visible on the bus). The 
problem is the lack of a third option "Integrated", in which only the Intel card would be 
powered off. Lenovo refused to introduce such an option into the BIOS, stating that it's a 
feature request and not a bug.

To save battery power I'd like to be able to run on the Intel card. However, with the 
"Switchable" option, powertop indicates huge power usage (24W), which can only be 
explained by the fact that both cards draw power.

Thus, my question is the following:
Is there a way to explicitly put a device into ACPI D0? I would like to do that to the ATI 
card on boot.

I've tried the following code:
http://ftp.chg.ru/pub/parallel/scyld/diag/pci-config.c
But it didn't work (the ATI card was still on).

Cheers,
Michal
