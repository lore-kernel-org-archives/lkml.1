Return-Path: <linux-kernel-owner+w=401wt.eu-S1760251AbYBALsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbYBALsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 06:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbYBALsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 06:48:11 -0500
Received: from hosted06.westnet.com.au ([203.10.1.221]:56319 "EHLO
	hosted06.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683AbYBALsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 06:48:10 -0500
Message-ID: <47A30604.6070602@snapgear.com>
Date: Fri, 01 Feb 2008 21:44:04 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: torvalds@linux-foundation.org, gerg@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [M68KNOMMU]: platform setup for 520x ColdFire parts
References: <200802010734.m117YAx4022578@goober> <20080201084817.GB10969@uranus.ravnborg.org>
In-Reply-To: <20080201084817.GB10969@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Branch: TNG-Outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Sam,

Sam Ravnborg wrote:
> On Fri, Feb 01, 2008 at 05:34:10PM +1000, Greg Ungerer wrote:
>> Switch to platform style configuration for 520x ColdFire parts.
>> Initial support is for the UARTs. DMA support moved to common code
>> for all ColdFire parts.
>>
>> +static struct mcf_platform_uart m520x_uart_platform[] = {
>> +	{
>> +		.mapbase	= MCF_MBAR + MCFUART_BASE1,
>> +		.irq		= MCFINT_VECBASE + MCFINT_UART0,
>> +	},
>> +	{
>> +		.mapbase 	= MCF_MBAR + MCFUART_BASE2,
>> +		.irq		= MCFINT_VECBASE + MCFINT_UART1,
>> +	},
>> +	{
>> +		.mapbase 	= MCF_MBAR + MCFUART_BASE3,
>> +		.irq		= MCFINT_VECBASE + MCFINT_UART2,
>> +	},
>> +	{ },
>> +};
> const?
> Same comments for the rest of the patch and the other similar patches.
> 
> Note: Use __initdataconst for const data as replacement for __initdata.

I am confused, __initdataconst?

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a Secure Computing Company      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
