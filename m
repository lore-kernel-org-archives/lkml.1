Return-Path: <linux-kernel-owner+w=401wt.eu-S933839AbXFRXsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933839AbXFRXsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 19:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764632AbXFRXsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 19:48:41 -0400
Received: from ns2.suse.de ([195.135.220.15]:51905 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762556AbXFRXsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 19:48:40 -0400
To: John Keller <jpk@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, steiner@sgi.com
Subject: Re: [PATCH] - Add IOAPIC NMI support on x86_64
References: <20070618215700.8097.77403.79754@attica.americas.sgi.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 19 Jun 2007 02:44:43 +0200
In-Reply-To: <20070618215700.8097.77403.79754@attica.americas.sgi.com>
Message-ID: <p73vedkrcw4.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Keller <jpk@sgi.com> writes:

> Add support for IOAPIC NMI interrupts on x86_64.
> 
> Changes include the following:
> 
>   - Obtain the NMI IOAPIC info via an ACPI NMI SRC structure that is
>     part of the MADT, and program the IOAPIC redirection register.
>     The NMI SRC struct will contain the GSI of the NMI interrupt.
> 
>   - Setup irq_desc[] and irq_2_pin[] entries for the NMI interrupt irq,
>     which will be used by the generic mask/unmask routines. This will
>     allow a driver to enable/disable the NMI interrupt via
>     enable/disable_irq().

What's the motivation for this patch? 

-Andi
