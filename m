Return-Path: <linux-kernel-owner+w=401wt.eu-S1759226AbXFVPmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226AbXFVPmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 11:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbXFVPl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 11:41:57 -0400
Received: from khc.piap.pl ([195.187.100.11]:58766 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757447AbXFVPl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 11:41:57 -0400
To: pharon@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Dual slot PCI riser messes up ivtv
References: <1182426585.9143.2.camel@iamer-laptop>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 22 Jun 2007 17:41:53 +0200
In-Reply-To: <1182426585.9143.2.camel@iamer-laptop> (Islam Amer's message of "Thu, 21 Jun 2007 14:49:45 +0300")
Message-ID: <m3bqf8ro72.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Islam Amer <pharon@gmail.com> writes:

> [   37.298400] ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 17 (level,
> low) -> IRQ 22
> [   37.298413] saa7134[0]: found at 0000:00:05.0, rev: 1, irq: 22,
> latency: 32, mmio: 0x0

The riser card must not be very active as the device(s) are sitting
on bus #0, that means no PCI-PCI bridge.

BTW: REQ/GraNT lines are not a problem and probably that's what the
manufacturer considers "active". IDSEL lines may be a problem (they
define device#, must not clash with other devices, and it would be
nice if the BIOS recognized them). IRQ lines are usually the main
problem.

OTOH I wonder if we should make it possible to force IRQs on
per-device basis? Or is it already possible?
-- 
Krzysztof Halasa
