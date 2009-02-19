Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbZBSJXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbZBSJXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 04:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbZBSJWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 04:22:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753841AbZBSJWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 04:22:42 -0500
Date: Thu, 19 Feb 2009 01:22:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Pflug <dtpflug@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [BUG] >2.6.27 dies at cardbus init on laptop
Message-Id: <20090219012200.7fe85912.akpm@linux-foundation.org>
In-Reply-To: <499B0FD7.2050906@gmail.com>
References: <499B0FD7.2050906@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-acpi)

On Tue, 17 Feb 2009 14:28:23 -0500 David Pflug <dtpflug@gmail.com> wrote:

> While trying to boot kernels greater than 2.6.27 on this Toshiba
> Satellite 1135-S155, it freezes while initializing Texas Instruments
> PCI1410 PC card Cardbus Controller [104c:ac50]. However, it boots with
> pci=noacpi. The IRQ of the cardbus is shared by one of the USB
> controllers and the IDE controller.
> 
> Identical symptoms on 2.6.29rc5.
> 
> Last few messages with default kernel line:
> pci 0000:00:1e.0:   PREFETCH window: 0x00000040000000-0x0000004bffffff
> pci 0000:02:02.0: enabling device (0000 -> 0003)
> ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
> PCI: setting IRQ 11 as level-triggered
> pci 0000:02:02.0: PCI INT A -> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
> 
> dmesg with acpi=off:
> http://dpaste.com/hold/121766/
> 
> Kernel config:
> http://dpaste.com/hold/121721/
> 
> lspci output:
> http://dpaste.com/hold/121768/

presumably an acpi-related thing.

> Is there anything else I can do to help debug?

Best to raise a report against acpi at bugzilla.kernel.org, please.

Often it's better to report kernel bugs via email, but acpi is
exceptional in that regard.  It's all a bit confusing.

