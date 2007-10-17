Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbXJQEkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbXJQEkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 00:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbXJQEkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 00:40:06 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:48605 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXJQEkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 00:40:05 -0400
Date: Tue, 16 Oct 2007 22:40:03 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Luming Yu <luming.yu@gmail.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC patch] fallback to "no irq" hack for case of no pnp_irq allocated for 8250_pnp
Message-ID: <20071017044003.GC16728@parisc-linux.org>
References: <3877989d0710161950n3d255330lf55e190dde628277@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3877989d0710161950n3d255330lf55e190dde628277@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 10:50:53AM +0800, Luming Yu wrote:
> There is a "ttyS1 irq is -1" problem observed on tiger4 which cause
> the serial port broken.
> It is because that there is __no__ ACPI IRQ resource assigned for the
> serial port. So the value of the IRQ for the port is never changed
> since it got initialized to -1. The attached patch falls back to the
> "no irq" hack for this case. It works for me. Please review and test.

Seems reasonable to me.  Although arguably pnp_irq is broken, since
Linus has decreed that 0 means no irq on Linux.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
