Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbZA1Xje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbZA1Xje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756186AbZA1XjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:39:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44337 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060AbZA1XjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:39:14 -0500
Message-ID: <4980EAA1.8020600@zytor.com>
Date: Wed, 28 Jan 2009 15:30:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] x86: do not expose CONFIG_BSWAP to userspace
References: <20090127222825.GA27097@elte.hu> <1233179884.6717.59.camel@brick> <4980D913.3000505@zytor.com> <200901290024.09815.arnd@arndb.de>
In-Reply-To: <200901290024.09815.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> I take this as a strong indication that user space applications
> won't generally expect to get the bswap instruction from including
> the kernel headers. For the longest time, we actually had
> 
> /* For avoiding bswap on i386 */
> #ifdef __KERNEL__
> #include <linux/config.h>
> #endif
> 
> which I read as explicitly using the portable i386 version for
> all user space.
> 

This is true, although it would be nice to be able to generate BSWAP now 
when most distros compile with -march=i586 or higher.  The reason noone 
cared for the longest time was that noone wanted to compile userspace 
for anything other than the i386 baseline.

	-hpa

