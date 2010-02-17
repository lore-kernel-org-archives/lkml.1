Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0BQIeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 03:34:50 -0500
Received: from poutre.nerim.net ([62.4.16.124]:61334 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab0BQIet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 03:34:49 -0500
Date: Wed, 17 Feb 2010 09:34:46 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the i2c tree
Message-ID: <20100217093446.2e610f45@hyperion.delvare>
In-Reply-To: <20100217113855.7ebf3d39.sfr@canb.auug.org.au>
References: <20100217113855.7ebf3d39.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010 11:38:55 +1100, Stephen Rothwell wrote:
> Hi Jean,
> 
> After merging the i2c tree, today's linux-next build (powerpc
> ppc64_defconfig) produced warnings like this:
> 
> In file included from include/linux/bitops.h:17,
>                  from include/linux/kernel.h:15,
>                  from drivers/i2c/i2c-boardinfo.c:19:
> arch/powerpc/include/asm/bitops.h:226: warning: declaration of 'ffs' shadows a built-in function
> 
> The x86_64 allmodconfig produces similar:
> 
> In file included from include/linux/bitops.h:17,
>                  from include/linux/kernel.h:15,
>                  from next/drivers/i2c/i2c-boardinfo.c:19:
> arch/x86/include/asm/bitops.h:395: warning: declaration of 'ffs' shadows a built-in function
> 
> Exposed by commit fa4f62e9f3a85490aebe8857e2208c37da851ce3 ("i2c: Build
> core and algo drivers with -Wshadow").
> 
> Jean, I realise that these warnings are not something your tree has
> added, just that you have exposed them.  They are a bit annoying,
> though.  I am using gcc v4.4.3.

Oh well. I had the hope that at least the header files were
Wshadow-compliant so it could be enabled for selected source files. Not
getting any warning on my own system when I tried, I thought it was
fine... If it is not, then I'll just remove this patch from my tree.
Sorry for the noise and thanks for reporting.

-- 
Jean Delvare
