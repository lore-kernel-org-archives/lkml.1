Return-Path: <linux-kernel-owner+w=401wt.eu-S934449AbYBGVyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934449AbYBGVyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761026AbYBGVye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:54:34 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52429 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758525AbYBGVyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:54:33 -0500
Date: Thu, 7 Feb 2008 21:54:21 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Introduce HAVE_IDE to support flexible IDE per arch configuration
Message-ID: <20080207215421.GJ28435@flint.arm.linux.org.uk>
References: <20080207214256.GA22572@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207214256.GA22572@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 10:42:56PM +0100, Sam Ravnborg wrote:
> Following patch introduce HAVE_IDE to support flexible per
> arch or even per. sub-arch configuration of IDE support.
> This patch is needed to allow arm to use the generic
> drivers/Kconfig file.
> 
> Introducing HAVE_IDE so each arch explicit select HAVE_IDE
> if supported allowed us to get rid of HAS_IOMEM which
> is anyway overloaded.
> And doing it this way is a much better way to document which
> architectures that supports IDE.
> Furthermore the decision if IDE is supported or not is
> distributed.
> Consider seeing this all over:
> 
> -if PCMCIA || ARCH_CLPS7500 || ARCH_IOP32X || ARCH_IOP33X || ARCH_IXP4XX \
> -       || ARCH_L7200 || ARCH_LH7A40X || ARCH_PXA || ARCH_RPC \
> -       || ARCH_S3C2410 || ARCH_SA1100 || ARCH_SHARK || FOOTBRIDGE \
> -       || ARCH_IXP23XX
>  source "drivers/ide/Kconfig"
> -endif
> 
> Only s390 and um does not support IDE from my quick
> investigation, if there are others let me know.
> [Added linux-arch to catch all arch maintainers].
> 
> Comments?

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
