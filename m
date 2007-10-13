Return-Path: <linux-kernel-owner+w=401wt.eu-S1763808AbXJMO7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763808AbXJMO7v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761611AbXJMOr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:47:28 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4300 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762656AbXJMOrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:47:25 -0400
Date: Sat, 13 Oct 2007 15:47:14 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Adrian Bunk <bunk@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: checkpatch: ERROR: Does not appear to be a unified-diff format patch
Message-ID: <20071013144714.GC31579@shadowen.org>
References: <Pine.LNX.4.64.0710131424470.12088@anakin> <20071013124733.GA4211@stusta.de> <Pine.LNX.4.64.0710131453530.31913@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710131453530.31913@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
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
> /([-+]\d+)\b/ seems to imply /$1,1/

Yep, that occurs a lot in the second parameter which we expect this and
cope with it.  Will fix this for the next release.

Thanks for the analysis.

-apw
