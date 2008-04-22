Return-Path: <linux-kernel-owner+w=401wt.eu-S1761578AbYDVIiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761578AbYDVIiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 04:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbYDVIhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 04:37:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37429 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877AbYDVIhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 04:37:54 -0400
Date: Tue, 22 Apr 2008 09:37:22 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: drivers/mfd/htc-pasic3.c:22:31: error: asm/arch/pxa-regs.h: No such file or directory
Message-ID: <20080422083722.GA3609@flint.arm.linux.org.uk>
References: <20080422074124.GA12187@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422074124.GA12187@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 09:41:24AM +0200, Ingo Molnar wrote:
> 
> make allyesconfig (on 64-bit x86) build fails on latest -git with the 
> following message:
> 
> drivers/mfd/htc-pasic3.c:22:31: error: asm/arch/pxa-regs.h: No such file or directory
> 
> i suspect this driver was not supposed to be buildable on non-ARM-PXA? 
> The patch below should fix this.

Known issue.  Thanks.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
