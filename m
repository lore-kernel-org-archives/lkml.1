Return-Path: <linux-kernel-owner+w=401wt.eu-S1760444AbZACX3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760444AbZACX3m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 18:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760121AbZACX3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 18:29:34 -0500
Received: from styx.suse.cz ([82.119.242.94]:46336 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760044AbZACX3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 18:29:34 -0500
Date: Sun, 4 Jan 2009 00:29:31 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alberto Bertogli <albertito@blitiri.com.ar>
cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, trivial@kernel.org,
       corbet@lwn.net
Subject: Re: [PATCH] Fix small typo in bio.h's documentation
In-Reply-To: <1230591376-9001-1-git-send-email-albertito@blitiri.com.ar>
Message-ID: <alpine.LNX.1.10.0901040028561.5377@jikos.suse.cz>
References: <1230591376-9001-1-git-send-email-albertito@blitiri.com.ar>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2008, Alberto Bertogli wrote:

> Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
> ---
>  include/linux/bio.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 6a64209..b29e2b3 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -135,7 +135,7 @@ struct bio {
>   * bit 1 -- rw-ahead when set
>   * bit 2 -- barrier
>   *	Insert a serialization point in the IO queue, forcing previously
> - *	submitted IO to be completed before this oen is issued.
> + *	submitted IO to be completed before this one is issued.
>   * bit 3 -- synchronous I/O hint: the block layer will unplug immediately
>   *	Note that this does NOT indicate that the IO itself is sync, just
>   *	that the block layer will not postpone issue of this IO by plugging.
> -- 
> 1.6.1.302.gccd4d

Has anyone merged this patch through his tree (Jens or Documentation 
people?). If not, I will take it through trivial tree.

Thanks,

-- 
Jiri Kosina
SUSE Labs
