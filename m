Return-Path: <linux-kernel-owner+w=401wt.eu-S1762288AbXJMMrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762288AbXJMMrU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 08:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbXJMMrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 08:47:08 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60500 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753227AbXJMMrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 08:47:06 -0400
Date: Sat, 13 Oct 2007 14:47:33 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: checkpatch: ERROR: Does not appear to be a unified-diff format
	patch
Message-ID: <20071013124733.GA4211@stusta.de>
References: <Pine.LNX.4.64.0710131424470.12088@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710131424470.12088@anakin>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2007 at 02:28:00PM +0200, Geert Uytterhoeven wrote:
> scripts/checkpatch.pl doesn't seem to like this patch:
> 
> $ scripts/checkpatch.pl m68k-export-asm-cachectl-h.diff 
> ERROR: Does not appear to be a unified-diff format patch
>...
> --- a/include/asm-m68k/Kbuild
> +++ b/include/asm-m68k/Kbuild
> @@ -1 +1,2 @@
>... ^^

Broken patch, this has to be "-1,1".

> Gr{oetje,eeting}s,
> 
> 						Geert

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

