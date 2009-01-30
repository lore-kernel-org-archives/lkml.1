Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZA3TgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZA3TgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 14:36:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZA3Tfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 14:35:54 -0500
Received: from styx.suse.cz ([82.119.242.94]:59587 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752187AbZA3Tfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 14:35:54 -0500
Date: Fri, 30 Jan 2009 20:35:52 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alberto Bertogli <albertito@blitiri.com.ar>
cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, trivial@kernel.org,
       corbet@lwn.net
Subject: Re: [PATCH] Fix typo in bio_split()'s documentation
In-Reply-To: <1232933774-12210-1-git-send-email-albertito@blitiri.com.ar>
Message-ID: <alpine.LNX.1.10.0901302035180.6035@jikos.suse.cz>
References: <1232933774-12210-1-git-send-email-albertito@blitiri.com.ar>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan 2009, Alberto Bertogli wrote:

> Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
> ---
>  fs/bio.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bio.c b/fs/bio.c
> index 062299a..4fb5046 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -1414,8 +1414,7 @@ static void bio_pair_end_2(struct bio *bi, int err)
>  }
>  
>  /*
> - * split a bio - only worry about a bio with a single page
> - * in it's iovec
> + * split a bio - only worry about a bio with a single page in its iovec
>   */
>  struct bio_pair *bio_split(struct bio *bi, int first_sectors)
>  {

Haven't found this in today's next -> applied to trivial tree.

Thanks,

-- 
Jiri Kosina
SUSE Labs
