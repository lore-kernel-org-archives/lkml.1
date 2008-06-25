Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYFYVVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYFYVVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 17:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYFYVUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 17:20:54 -0400
Received: from outbound-mail-22.bluehost.com ([69.89.21.17]:57384 "HELO
	outbound-mail-22.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752095AbYFYVUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 17:20:54 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David Vrabel <david.vrabel@csr.com>
Subject: Re: PCI: MSI interrupts masked using prohibited method
Date: Wed, 25 Jun 2008 14:20:51 -0700
User-Agent: KMail/1.9.9
Cc: Kernel development list <linux-kernel@vger.kernel.org>
References: <4860D09D.4060801@csr.com>
In-Reply-To: <4860D09D.4060801@csr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251420.51751.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 24, 2008 3:46 am David Vrabel wrote:
> PCI MSI interrupts are masked and unmasked using a method (by writing
> the MSI Enable capability bit) that is prohibited by the PCI specification.

Yeah, it's probably quite a bit slower too (I assume you're talking about 
io_apic_64's msi_mask_irq).  Seems like masking this at the ioapic level 
would make more sense anyway...

> This behaviour can cause missed interrupts with some devices if the
> interrupt is asserted by the hardware while MSI is disabled.
>
> I believe the interrupt should be masked/unmasked on the interrupt
> controller (the APIC on x86, for example).   I'm going to test this now
> and see if it works.

Great, thanks.

Jesse
