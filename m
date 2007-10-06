Return-Path: <linux-kernel-owner+w=401wt.eu-S1761107AbXJFKlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761107AbXJFKlf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 06:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbXJFKl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 06:41:27 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:53085 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbXJFKl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 06:41:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hklEXm/gIWw9VfrzmnLBmNDGl25bG2LRYQoCFutFwExMERls6bshRDtvHxsttrJIpmDbxHOl2fnOTc6Ik5+4++I7tKpObo0XFk9BG9zTYW2caSNCS12N4VEJ/qar4olmBFJ4/DU0xSfuhqT+MuY1Q+roxuW8er3Nli6bhSYez5g=
Message-ID: <47076651.8020801@gmail.com>
Date: Sat, 06 Oct 2007 12:41:21 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       airlied@linux.ie, arashi@sacredchao.net
Subject: Re: Revert "intel_agp: fix stolen mem range on G33"
References: <4706D4B1.6050101@sacredchao.net> <20071006044221.GA14767@fattire.cabal.ca> <20071006053410.GB14767@fattire.cabal.ca> <20071006054234.GC14767@fattire.cabal.ca>
In-Reply-To: <20071006054234.GC14767@fattire.cabal.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2007 07:42 AM, Kyle McMartin wrote:
> This reverts commit f443675affe3f16dd428e46f0f7fd3f4d703eeab, which
> breaks horribly if you aren't running an unreleased xf86-video-intel
> driver out of git.

I guess, this will break my graphics, no?
http://lkml.org/lkml/2007/9/20/447

> Conflicts:
> 
> 	drivers/char/agp/intel-agp.c
> 
> Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
> ---
> 
>  drivers/char/agp/intel-agp.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
> index a5d0e95..141ca17 100644
> --- a/drivers/char/agp/intel-agp.c
> +++ b/drivers/char/agp/intel-agp.c
> @@ -506,11 +506,6 @@ static void intel_i830_init_gtt_entries(void)
>  			break;
>  		}
>  	} else {
> -		/* G33's GTT stolen memory is separate from gfx data
> -		 * stolen memory.
> -		 */
> -		if (IS_G33)
> -			size = 0;
>  		switch (gmch_ctrl & I855_GMCH_GMS_MASK) {
>  		case I855_GMCH_GMS_STOLEN_1M:
>  			gtt_entries = MB(1) - KB(size);


-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
