Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab0BNTlM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 14:41:12 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35973 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab0BNTlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 14:41:11 -0500
Date: Sun, 14 Feb 2010 19:40:46 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: =?utf-8?B?5p2o5Z+O?= <gump.yang@gmail.com>
Cc: Nicolas Pitre <nico@marvell.com>, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: apply chip ID
Message-ID: <20100214194046.GA11315@n2100.arm.linux.org.uk>
References: <d4d4c7ef1002140814x5c406afaq7f60dc584e389348@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d4d4c7ef1002140814x5c406afaq7f60dc584e389348@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 12:14:08AM +0800, 杨城 wrote:
> diff --git a/arch/arm/tools/mach-types b/arch/arm/tools/mach-types
> index 07b976d..629b858 100644
> --- a/arch/arm/tools/mach-types
> +++ b/arch/arm/tools/mach-types
> @@ -2635,3 +2635,4 @@ hw90240			MACH_HW90240		HW90240			2648
> dm365_leopard		MACH_DM365_LEOPARD	DM365_LEOPARD		2649
> mityomapl138		MACH_MITYOMAPL138	MITYOMAPL138		2650
> scat110			MACH_SCAT110		SCAT110			2651
> +ak780x			MACH_AK780X		AK780X			2557
> +ak880x			MACH_AK880X		AK880X			2558

This file is periodically replaced; as such taking patches for the file is
senseless.

Moreover, your two additions refer to a number which is already allocated
and in use for bcmring_evm_jazz and bcmring_sp - you can not use these
numbers.
