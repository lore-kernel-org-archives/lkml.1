Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbZASGSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbZASGSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 01:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757372AbZASGR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 01:17:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60343 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361AbZASGR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 01:17:56 -0500
Message-ID: <49741AE9.3050005@zytor.com>
Date: Sun, 18 Jan 2009 22:17:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, matthew@wil.cx
Subject: Re: [PATCH] x86: Remove never-called arch_setup_msi_irq()
References: <2882ab91a8588e9fe2ea45c89d1bc386850a94a3.1232345159.git.michael@ellerman.id.au>
In-Reply-To: <2882ab91a8588e9fe2ea45c89d1bc386850a94a3.1232345159.git.michael@ellerman.id.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman wrote:
> Since commit 75c46fa, "x64, x2apic/intr-remap: MSI and MSI-X
> support for interrupt remapping infrastructure", x86 has had an
> implementation of arch_setup_msi_irqs().
> 
> That implementation does not call arch_setup_msi_irq(), instead it calls
> setup_irq(). No other x86 code calls arch_setup_msi_irq().
> 
> That leaves only arch_setup_msi_irqs() in drivers/pci/msi.c, but that
> routine is overridden by the x86 version of arch_setup_msi_irqs().
> 
> So arch_setup_msi_irq() is dead code, remove it.

Applied to tip:x86/cleanups, thanks!

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

