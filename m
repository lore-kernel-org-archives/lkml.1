Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbXJMNwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbXJMNwR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 09:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbXJMNwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 09:52:01 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37680 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754036AbXJMNwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 09:52:00 -0400
Date: Sat, 13 Oct 2007 15:52:29 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: checkpatch: ERROR: Does not appear to be a unified-diff format
	patch
Message-ID: <20071013135229.GB4211@stusta.de>
References: <Pine.LNX.4.64.0710131424470.12088@anakin> <20071013124733.GA4211@stusta.de> <Pine.LNX.4.64.0710131453530.31913@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710131453530.31913@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2007 at 02:55:01PM +0200, Jan Engelhardt wrote:
> 
> On Oct 13 2007 14:47, Adrian Bunk wrote:
> >On Sat, Oct 13, 2007 at 02:28:00PM +0200, Geert Uytterhoeven wrote:
> >> scripts/checkpatch.pl doesn't seem to like this patch:
> >> 
> >> $ scripts/checkpatch.pl m68k-export-asm-cachectl-h.diff 
> >> ERROR: Does not appear to be a unified-diff format patch
> >>...
> >> --- a/include/asm-m68k/Kbuild
> >> +++ b/include/asm-m68k/Kbuild
> >> @@ -1 +1,2 @@
> >>... ^^
> >
> >Broken patch, this has to be "-1,1".
> 
> No, this is actually how diff outputs it.
>...

You seem to be right.

That's a really strange part of the unidiff format - you have to write
",0" or ",2", but you can omit a ",1".

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

