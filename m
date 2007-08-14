Return-Path: <linux-kernel-owner+w=401wt.eu-S936106AbXHNApE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936106AbXHNApE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 20:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757570AbXHNAov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 20:44:51 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:35092 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432AbXHNAou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 20:44:50 -0400
Date: Tue, 14 Aug 2007 09:43:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linuxsh-shmedia-dev@lists.sourceforge.net
Subject: Re: [PATCH] [464/2many] MAINTAINERS - SUPERH (sh)
Message-ID: <20070814004347.GA633@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>, joe@perches.com,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	linuxsh-shmedia-dev@lists.sourceforge.net
References: <46bffc05.Zi+AgReNUMWozyrG%joe@perches.com> <46bffc03.4E2RshjUw+dyxP1/%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46bffc05.Zi+AgReNUMWozyrG%joe@perches.com> <46bffc03.4E2RshjUw+dyxP1/%joe@perches.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 11:36:51PM -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3e51fc6..f42712c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4414,6 +4414,8 @@ M:	lethal@linux-sh.org
>  L:	linuxsh-dev@lists.sourceforge.net (subscribers-only)
>  W:	http://www.linux-sh.org
>  S:	Maintained
> +F:	arch/sh/
> +F:	arch/asm-sh/
>  
I suppose you meant include/ here?

On Sun, Aug 12, 2007 at 11:36:53PM -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f42712c..df097fb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4423,6 +4423,8 @@ M:	lethal@linux-sh.org
>  L:	linuxsh-shmedia-dev@lists.sourceforge.net
>  W:	http://www.linux-sh.org
>  S:	Maintained
> +F:	arch/sh64/
> +F:	arch/asm-sh64/
>  

Likewise?

The more pressing question that comes to mind is what the point of this
is? Architecture related drivers and things of that nature fall under
this also, as most folks don't create a separate entry for every trivial
driver. Are you intending to have a long list of individual drivers here
that your script can parse?

Is there actually a problem with people just opening up MAINTAINERS in a
text file? Surely this is not such a non-intuitive thing, there are
already keywords there you can grep for.
