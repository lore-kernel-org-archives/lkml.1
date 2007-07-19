Return-Path: <linux-kernel-owner+w=401wt.eu-S1765322AbXGSVJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765322AbXGSVJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758890AbXGSVIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:08:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44914 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485AbXGSVIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:08:52 -0400
Message-ID: <469FD2D3.3000104@zytor.com>
Date: Thu, 19 Jul 2007 14:08:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Matthew Wilcox <matthew@wil.cx>, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Update .gitignore for arch/i386/boot
References: <20070719190910.GX14791@parisc-linux.org> <20070719194434.GB6524@martell.zuzino.mipt.ru>
In-Reply-To: <20070719194434.GB6524@martell.zuzino.mipt.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Thu, Jul 19, 2007 at 01:09:10PM -0600, Matthew Wilcox wrote:
>> With the new setup code, we generate a couple more files
> 
>> --- a/arch/i386/boot/.gitignore
>> +++ b/arch/i386/boot/.gitignore
>> @@ -1,3 +1,5 @@
>>  bootsect
>>  bzImage
>>  setup
>> +setup.bin
>> +setup.elf
> 
> ACK
> 
> same chunk against arch/x86_64/boot/.gitignore
> 
> --- a/arch/x86_64/boot/.gitignore
> +++ b/arch/x86_64/boot/.gitignore
> @@ -1,3 +1,5 @@
>  bootsect
>  bzImage
>  setup
> +setup.bin
> +setup.elf
> 

Acked-by: H. Peter Anvin <hpa@zytor.com>

The old "bootsect" and "setup" could be removed, but it's probably
cleaner to leave them in in case people have old-kernel droppings still
around.

	-hpa
