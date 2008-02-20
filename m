Return-Path: <linux-kernel-owner+w=401wt.eu-S1764703AbYBTPol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764703AbYBTPol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYBTPob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:44:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62507 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbYBTPoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:44:30 -0500
Message-ID: <47BC4AAE.8020908@anagramm.de>
Date: Wed, 20 Feb 2008 16:43:42 +0100
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-fbdev-devel@lists.sourceforge.net
CC: Andrew Morton <akpm@linux-foundation.org>, adaplas@gmail.com,
       benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Linux-fbdev-devel] [PATCH 1/2] fb: add support for foreign endianness
References: <20080205154432.GA8749@localhost.localdomain>	<20080214224942.a0cb6218.akpm@linux-foundation.org>	<20080215164542.GB16810@localhost.localdomain>	<Pine.LNX.4.64.0802171030330.6848@anakin>	<20080218081847.e9e65f2f.krzysztof.h1@poczta.fm>	<19805.1203355811@turing-police.cc.vt.edu>	<47BA162C.5000807@anagramm.de> <1203381353.6740.59.camel@pasglop>	<47BABD3A.7010102@anagramm.de>	<20080219040530.7b1d115d.akpm@linux-foundation.org> <18363.31427.989835.105966@cargo.ozlabs.ibm.com>
In-Reply-To: <18363.31427.989835.105966@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+X3/4EnLclbiQkYcdOPa9+gl2Uf0vgAhUY9T8
 6G5J3SGyXSrfwJfx9k9Y+HF0FE4Zvib6Di44Tn0tZkNMzp9IFr
 c0jrSmnkNXqmWQRNPUz2w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras schrieb:
> Andrew Morton writes:
> 
>> Bizarrely, the original author of the patch (Anton) has fallen off the cc. 
>> Could whoever did that please thwap himself?
>>
>> Anyway, my head is now officially spinning.  Did anyone actually have a
>> reason why we shouldn't proceed with Anton's patch?
> 
> I was wondering if it would be sufficient to provide alternative
> versions of fb_readl, fb_writel etc. that do byte-swapping.  That
> would mean that all framebuffers would have to have the same
> endianness, but that would suffice for embedded systems such as
> Anton's and would end up a lot simpler IMHO.

Yes. At least the affected PowerPC platforms can do byte-swapping on
the fly, so this should be sufficient and without performance
penalty, AFAICS.

Regards,

Clemens
