Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbYF0MEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbYF0MEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757184AbYF0L6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:17 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:45310 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608AbYF0L6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:58:04 -0400
Date: Fri, 27 Jun 2008 12:57:34 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Johannes Weiner <hannes@saeurebad.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mmotm] fix double export of kobject_rename
In-Reply-To: <87wskbxg1o.fsf@skyscraper.fehenstaub.lan>
Message-ID: <Pine.LNX.4.64.0806271256570.16003@blonde.site>
References: <87wskbxg1o.fsf@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008, Johannes Weiner wrote:

> Probably a merging error, line comes from the merge with -next.
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> ---

Please try yesterday's .DATE=2008-06-26-14-32 mmotm,
I sent Andrew a similar fix and it should be okay now.
Also includes fix to endless bad page states once you boot.

Hugh

> 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index 8761ef6..abfb1e2 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -540,7 +540,6 @@ out:
>  	kfree(devpath);
>  	return error;
>  }
> -EXPORT_SYMBOL_GPL(kobject_rename);
>  
>  /**
>   * kobject_del - unlink kobject from hierarchy.
> --
