Return-Path: <linux-kernel-owner+w=401wt.eu-S1759349AbZA2WCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbZA2WCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbZA2WC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:02:27 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:46402 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbZA2WC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:02:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=a8BgQrvyr76UfDqAJYDQgRVwWVFx9sq/WmIairqqjQBAj+Zl2+qTkH8FBVTuwChaxT
         kUgV4S/SPaiGWsYESBHk1zacRNdtJL55Blx4uQbBJeo1wmwvXS/Pa9CkulWTY5UsLkpE
         NRqzaA4LfxPeUy3dGepTBBMCT7S8BHuub18dc=
MIME-Version: 1.0
Date: Thu, 29 Jan 2009 14:02:25 -0800
Message-ID: <74ae4f6a0901291402j19575c87g418bee66ba9f3519@mail.gmail.com>
Subject: x86_64 IOAPIC
From: SUJIT V <sujit.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
    We have a IBM Qauadcore 8 CPU system running x86_64 linux 2.6.23.
We were doing some performance test. (disk & network).
The eth0 IRQ is pinned to CPU0.  The aacraid interrupt has not been
assigned any smp affinity.

On the system we see in (/proc/interrupts) that when the eth0
interrupt rate is high, the aacraid interrupt counter for CPU0 does
not increase as much compared to aacraid interrupts handled by other
CPUs .
This shows that IOAPIC is doing some load balancing.

I wanted to check the code which is doing this load balancing. I
checked the file arch/x86_64/kernel/io_apic.c. I could not find any
irq balancing stuff out there.
I went through some archived discussions about the x86_64 ioapic irq
balancing. Most of the discussions were about using irqbalance
utility.


Could some one point me to the relevant piece of io_apic code ?


Thanks
