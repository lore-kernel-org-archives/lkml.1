Return-Path: <linux-kernel-owner+w=401wt.eu-S934249AbZDAVXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934249AbZDAVXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 17:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933726AbZDAVXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 17:23:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51216 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbZDAVXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 17:23:08 -0400
Message-ID: <49D3DABA.2050001@zytor.com>
Date: Wed, 01 Apr 2009 14:20:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Will Newton <will.newton@gmail.com>,
       Geert Uytterhoeven <geert.uytterhoeven@gmail.com>,
       michal.simek@petalogix.com,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
       Chen Liqin <liqin.chen@sunplusct.com>
Subject: Re: [RFC] asm-generic/{unistd,types,posix_types}.h for new arch
References: <49D071A8.4010703@petalogix.com> <200904011611.53355.arnd@arndb.de> <87a5b0800904010739g3564eb1fhf32afcfee4936c4b@mail.gmail.com> <200904011704.13581.arnd@arndb.de>
In-Reply-To: <200904011704.13581.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> Unfortunately, there is no generic way to detect the word size yet,
> but every architecture uses its own preprocessor macro (__x86_64__,
> __s390x__, __ppc64__). We also can't use CONFIG_64BIT in an user-exported
> interface header file, because the use space can also be compiled for
> 32 bits when the kernel uses 64 bits.
> 

Actually, gcc does have the _LP64 and __SIZEOF_POINTER__ macros (as well 
as __CHAR_BIT__), although I don't know how far back it does have that. 
     If it has been with us for long enough it might be possible to 
switch over to using panarch macros.

	-hpa

