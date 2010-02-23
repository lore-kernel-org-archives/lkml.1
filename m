Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab0BWCTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 21:19:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44475 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab0BWCTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 21:19:12 -0500
Message-ID: <4B833B13.7060109@kernel.org>
Date: Mon, 22 Feb 2010 18:18:59 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       x86@kernel.org
Subject: Re: linux-next: build failure in i386 since next-20100104
References: <20100222220340.4b0a19fb.sfr@canb.auug.org.au>
In-Reply-To: <20100222220340.4b0a19fb.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2010 03:03 AM, Stephen Rothwell wrote:
> Hi,
> 
> The i386 allmodconfig builds of linux-next have been failing since
> next-20100204 like this:
> 
> In file included from arch/x86/include/asm/uaccess.h:571,
>                  from include/linux/uaccess.h:5,
>                  from include/linux/highmem.h:6,
>                  from include/linux/pagemap.h:10,
>                  from include/linux/mempolicy.h:62,
>                  from include/linux/migrate.h:5,
>                  from mm/migrate.c:15:
> In function 'copy_from_user',
>     inlined from 'do_pages_stat' at mm/migrate.c:1009:
> arch/x86/include/asm/uaccess_32.h:212: error: call to 'copy_from_user_overflow' declared with attribute error: copy_from_user() buffer size is not provably correct
> 
> [Today's linux-next is the same except for the one line starting
> "inlined" which is now:
>     inlined from 'do_pages_stat' at mm/migrate.c:1012:
> ]
> 
>  I use gcc 4.4.3 for those compiles.  (See
> http://kisskb.ellerman.id.au/kisskb/buildresult/2118967/ for full logs.)
> 
> There doesn't seem to be any relevant change in the config from Feb 3 to
> 4:
> 
> +CONFIG_I2C_XILINX=m
> +CONFIG_RADIO_SAA7706H=m
> 
> and nothing else jumps out. The i386 defconfig and allnoconfig builds do
> not fail.

Already fixed in upstream, checkin 87b8d1adefa1548b591cbf0d63965987e2cf893d.

	-hpa

