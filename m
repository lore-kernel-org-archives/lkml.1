Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368Ab0APGDs (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 01:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936Ab0APGDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 01:03:47 -0500
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:21188 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750873Ab0APGDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 01:03:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=i2yghXExxQ0ICCOUUa+rhl/Td+PgtZTncqVFOzsTtlkaor88Rq0Bi+kUcprGvbSiu+EW4WgmJytWW9C3hD+xs4nlxCsMugUkK7V9GtNyQTliWeH5BS3MmezALZpBS8Z+bUFoHEwbbA90eeVIerdzViOJMANffebGY9Ozato2Grk=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: bHtgGhYVM1museP4Tj9Zicm4dQ7K_uht1iyUIhEftbf6aFtrV7d9lwcTodefsYcHLCEA9BD47wZeEUFTDtipj8fOvAr56Cx5sTJITBeN_iF4NrG12aAnbWqyuXwWEhS5bxb7hN6Q1o9dmPPIvzugekeuuRgFsvrG4A3_b4qqrvOJcsQdm_k38V8gFgq8ZfEaaJ6jYv67EL.KxQ7A1yWUk463kE53AbcXngQDnI95evToL2xz161cwh0wUUVk_1k6
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: flash_platform_data namespace collision
Date: Fri, 15 Jan 2010 22:03:45 -0800
User-Agent: KMail/1.9.10
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Mailing List <linux-kernel@vger.kernel.org>,
        "linux-embedded" <linux-embedded@vger.kernel.org>
References: <1263620475.29868.6280.camel@calx>
In-Reply-To: <1263620475.29868.6280.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001152203.45438.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 January 2010, Matt Mackall wrote:
> I've got a board here with SPI, NOR, and NAND flash devices and I've
> just run into a namespace collision on flash_platform_data from
> 
>  include/spi/flash.h
> 
> and
> 
>  arch/arm/include/asm/mach/flash.h
> 
> And each appears to have a bunch of users.

ISTR someone noting that before but omitting a patch.

You can do that one better.  :)

I think changing the SPI flash name will affect fewer platforms.

- Dave
