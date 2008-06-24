Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYFXCH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYFXCH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 22:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbYFXCHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 22:07:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34371 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101AbYFXCHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 22:07:11 -0400
Date: Mon, 23 Jun 2008 19:07:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kentaro Makita <k-makita@np.css.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, harvey.harrison@gmail.com
Subject: Re: [RESEND][PATCH -mm 1/2] vfs: fix coding style at dcache.c.
Message-Id: <20080623190705.04cedae2.akpm@linux-foundation.org>
In-Reply-To: <486051AA.8000507@np.css.fujitsu.com>
References: <486051AA.8000507@np.css.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008 10:45:14 +0900 Kentaro Makita <k-makita@np.css.fujitsu.com> wrote:

> o fix coding style at dcache.c. No behavior changed.
> 
> Signed-off-by: Kentaro Makita <k-makita@np.css.fujitsu.com>
> ---
>  fs/dcache.c |   21 ++++++++++-----------
>  1 files changed, 10 insertions(+), 11 deletions(-)
> 
> Index: b/fs/dcache.c
> ===================================================================
> --- a/fs/dcache.c	2008-06-05 11:44:26.000000000 +0900
> +++ b/fs/dcache.c	2008-06-05 11:48:57.000000000 +0900
> @@ -453,15 +453,15 @@ static void __shrink_dcache_sb(struct su
>  	int cnt = 0;
> 
>  	BUG_ON(!sb);
> -	BUG_ON((flags & DCACHE_REFERENCED) && count == NULL);
> +	BUG_ON((flags & DCACHE_REFERENCED) && !count);

A change like this isn't really a "fix".  Both styles are acceptable
and some people prefer the longer form.

