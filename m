Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbYJAH7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbYJAH7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 03:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYJAH73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 03:59:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49447 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbYJAH73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 03:59:29 -0400
Date: Wed, 1 Oct 2008 09:59:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>, Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] pcm_native: label out defined but not used
Message-ID: <20081001075921.GA25832@elte.hu>
References: <1222847847-7127-1-git-send-email-steven@uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222847847-7127-1-git-send-email-steven@uplinklabs.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0012]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:-ed Taskashi for this ALSA cleanup patch.)

* Steven Noonan <steven@uplinklabs.net> wrote:

> Signed-off-by: Steven Noonan <steven@uplinklabs.net>
> ---
>  sound/core/pcm_native.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
> index c487025..3953bf6 100644
> --- a/sound/core/pcm_native.c
> +++ b/sound/core/pcm_native.c
> @@ -3252,7 +3252,7 @@ static int snd_pcm_fasync(int fd, struct file * file, int on)
>  	runtime = substream->runtime;
>  
>  	err = fasync_helper(fd, file, on, &runtime->fasync);
> -out:
> +
>  	unlock_kernel();
>  	if (err < 0)
>  		return err;
> -- 
> 1.6.0.2
