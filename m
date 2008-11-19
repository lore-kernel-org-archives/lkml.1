Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700AbYKSGgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbYKSGgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 01:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbYKSGgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 01:36:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245AbYKSGgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 01:36:43 -0500
Date: Tue, 18 Nov 2008 22:36:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] Parport driver: disable pc-style parport on Blackfin
 systems
Message-Id: <20081118223601.3458d76f.akpm@linux-foundation.org>
In-Reply-To: <1226992362-30928-1-git-send-email-cooloney@kernel.org>
References: <1226992362-30928-1-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2008 15:12:42 +0800 Bryan Wu <cooloney@kernel.org> wrote:

> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/parport/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
> index 209b4a4..855f389 100644
> --- a/drivers/parport/Kconfig
> +++ b/drivers/parport/Kconfig
> @@ -36,7 +36,7 @@ if PARPORT
>  config PARPORT_PC
>  	tristate "PC-style hardware"
>  	depends on (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV && \
> -		(!M68K || ISA) && !MN10300 && !AVR32
> +		(!M68K || ISA) && !MN10300 && !AVR32 && !BLACKFIN
>  	---help---
>  	  You should say Y here if you have a PC-style parallel port. All
>  	  IBM PC compatible computers and some Alphas have PC-style

Again, you overestimate our mind-reading abilities.

Some poor schmuck has to work out whether we need this patch in one,
some or all of 2.6.25.x, 2.6.26.x, 2.6.27.x, 2.6.28 and 2.6.29.  This
poor schmuck cannot work that out unless you tell him what the damn
patch does!

If it fixes the build then sure, 2.6.28.  If it's just a
dont-compile-this-because-we-dont-have-the-hardware thing then I'd say
2.6.29.


