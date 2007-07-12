Return-Path: <linux-kernel-owner+w=401wt.eu-S935847AbXGLWKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935847AbXGLWKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 18:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760002AbXGLWJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 18:09:52 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:22061 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760794AbXGLWJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 18:09:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=g7pC6nMTXbyHjxBqmlT6bDw+n516LVqIiA4jUQsneEyA4BbvWhw579A5Ow7z7Sq4oxOskhsRayt7xu98JKnIi7giKakimHEeb6yD1v2LNN68oHhPzuXQ3GFBMiwb2A2GrzPa4qy8E88YvgwKTGV1BJAehRedwRFKhBmqzUqcDO4=
Message-ID: <9a8748490707121509w3feb3fd6sd566effca5266308@mail.gmail.com>
Date: Fri, 13 Jul 2007 00:09:36 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Matt LaPlante" <kernel1@cyberdogtech.com>
Subject: Re: [PATCH] 2.6.22 - Documentation Cleanup
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
In-Reply-To: <20070712114432.8f3d3b1c.kernel1@cyberdogtech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070709134516.f5e7dc07.kernel1@cyberdogtech.com>
	 <20070712114432.8f3d3b1c.kernel1@cyberdogtech.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/07, Matt LaPlante <kernel1@cyberdogtech.com> wrote:
> Version 2 with fixes suggested by Randy & Joe.
>
> On Mon, 9 Jul 2007 13:45:16 -0400
> Matt LaPlante <kernel1@cyberdogtech.com> wrote:
>
> > Fix misc small issues/typos/grammar in Documentation txts for 2.6.22.
> >

Looks good to me, except for a few minor bits outlined below.


> > Signed-off-by: Matt LaPlante <kernel1@cyberdogtech.com>
> > --
>
> diff -ru a/Documentation/arm/Samsung-S3C24XX/DMA.txt b/Documentation/arm/Samsung-S3C24XX/DMA.txt
> --- a/Documentation/arm/Samsung-S3C24XX/DMA.txt 2007-07-08 19:32:17.000000000 -0400
> +++ b/Documentation/arm/Samsung-S3C24XX/DMA.txt 2007-07-11 21:47:43.000000000 -0400
[snip]
>
>     struct s3c24xx_dma_order has a list of channels, and
> -   each channel within has a slot for a list of dma
> -   channel numbers. The slots are searched in order, for
> -   the presence of a dma channel number with DMA_CH_VALID
> +   each channel within has a slot for a list of DMA
> +   channel numbers. The slots are searched in order for
> +   the presence of a DMA channel number with DMA_CH_VALID
>     orred in.

"orred"?? Wouldn't "OR'ed" or similar be better?

[snip]
>
>  ** WARNING **
> -I may not be held responsible for any dammage or harm caused if you try to
> +I may not be held responsible for any damage or harm caused if you try to

I'm guessing that the original author really meant to write "I shall
not be held responsible ..."

[snip]
>
>  This is a symlink to the latest version, which at the time of writing is
>  20061214, the only release of kexec-tools-testing so far. As other versions
> -are made released, the older onese will remain available at
> +are made released, the older ones will remain available at

s/are made released/are released/

[snip]
> @@ -1172,7 +1172,7 @@
>         recommended version is 3.2 or later. Here, the F/W support is in
>         a stable and reliable condition. Wide-addressing is in addition
>         supported.
> -     Q: I get a Ooops message and something like "killing interrupt".
> +     Q: I get a oops message and something like "killing interrupt".

I believe that should be "Oops" - two o's, first one uppercase.

[snip]
>
> -   If you have extensive bugreports, including Ooops messages and
> +   If you have extensive bug reports, including oops messages and

"Oops" ?

[snip]
> @@ -10,10 +10,11 @@
>      cpu. This is not ideal and leads to code duplication i.e. Linux now has 4

s/cpu/CPU/ ?

[snip]


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
