Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbYEKPs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbYEKPs3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 11:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbYEKPsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 11:48:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:65458 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbYEKPsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 11:48:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=E53OeeA9C4Z8FXhqaFClgnfeBV3j+Ajzyfm0sbg8datcf/XkClMqqGqdblpgzyijuPLu7rq3ZH1l+8gJQC2VBrnyruVKcpuYwLehvQWm5iB+qv17awwjaDPLdRU6GRTJ/p8lYuUt87SiFXGezzIOpyhchl2jQccsKjPmMVC7CKs=
Date: Sun, 11 May 2008 20:43:35 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: perex@perex.cz, ricardo@scarybox.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/4] sound/isa: use unsigned for loop index
Message-ID: <20080511164335.GA19745@martell.zuzino.mipt.ru>
References: <Pine.LNX.4.64.0805111450000.29620@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805111450000.29620@ask.diku.dk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 02:50:33PM +0200, Julia Lawall wrote:
> A few more cases in the spirit of the patch "Trivial: Replacement of always
> >0 ints with unsigned ints" submitted by Ricardo Martins <ricardo@scarybox.net>

And rationale for those would be ...?

> --- a/sound/isa/es1688/es1688_lib.c
> +++ b/sound/isa/es1688/es1688_lib.c
> @@ -101,7 +101,7 @@ static unsigned char snd_es1688_mixer_re
>  
>  static int snd_es1688_reset(struct snd_es1688 *chip)
>  {
> -	int i;
> +	unsigned int i;
>  
>  	outb(3, ES1688P(chip, RESET));		/* valid only for ESS chips, SB -> 1 */
>  	udelay(10);

