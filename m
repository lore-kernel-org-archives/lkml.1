Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbXLVIbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbXLVIbk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 03:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbXLVIbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 03:31:33 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:44762 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbXLVIbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 03:31:33 -0500
Date: Sat, 22 Dec 2007 09:33:23 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       trivial@kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH 1/3] Remove unused dependency
Message-ID: <20071222083323.GA22653@uranus.ravnborg.org>
References: <1198306931-5258-1-git-send-email-joe@perches.com> <1198306931-5258-2-git-send-email-joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198306931-5258-2-git-send-email-joe@perches.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2007 at 11:02:09PM -0800, Joe Perches wrote:
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/alpha/boot/Makefile |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/alpha/boot/Makefile b/arch/alpha/boot/Makefile
> index cd14388..c53169c 100644
> --- a/arch/alpha/boot/Makefile
> +++ b/arch/alpha/boot/Makefile
> @@ -112,5 +112,3 @@ $(obj)/bootpheader: $(obj)/bootloader.lds $(OBJ_bootph) $(LIBS_Y) FORCE
>  
>  $(obj)/bootpzheader: $(obj)/bootloader.lds $(OBJ_bootpzh) $(LIBS_Y) FORCE
>  	$(call if_changed,ld)
> -
> -$(obj)/misc.o: lib/inflate.c

But arch/alpha/boot/mixc.c have:
#include "../../../lib/inflate.c"

So this is wrong.

	Sam
