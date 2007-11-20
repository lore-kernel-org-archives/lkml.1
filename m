Return-Path: <linux-kernel-owner+w=401wt.eu-S1758591AbXKTJMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbXKTJMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 04:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755603AbXKTJLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 04:11:46 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:1654 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbXKTJLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 04:11:45 -0500
Date: Tue, 20 Nov 2007 09:11:00 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Print filenames of patches
Message-ID: <20071120091047.GA12066@shadowen.org>
References: <Pine.LNX.4.64.0711181103070.1009@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711181103070.1009@anakin>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2007 at 11:03:47AM +0100, Geert Uytterhoeven wrote:
> checkpatch: Print filenames of patches instead of the very uninformative
> `Your patch'.

Well this isn't quite enough as we often use this thing checking its
stdin.  Which leads to an even less useful '- has no obvious ...'.  I
guess a hybrid would be an improvement.

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> This patch is not `checkpatch' clean :-)
> Although I shortened 2 lines, they're still longer than 80 characters...

Heh, yeah its a pig getting those RE's into 80 chars.

>  scripts/checkpatch.pl |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1408,10 +1408,10 @@ sub process {
>  		}
>  	}
>  	if ($clean == 1 && $quiet == 0) {
> -		print "Your patch has no obvious style problems and is ready for submission.\n"
> +		print "$filename has no obvious style problems and is ready for submission.\n"
>  	}
>  	if ($clean == 0 && $quiet == 0) {
> -		print "Your patch has style problems, please review.  If any of these errors\n";
> +		print "$filename has style problems, please review.  If any of these errors\n";
>  		print "are false positives report them to the maintainer, see\n";
>  		print "CHECKPATCH in MAINTAINERS.\n";
>  	}

-apw
