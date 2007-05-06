Return-Path: <linux-kernel-owner+w=401wt.eu-S933409AbXEFJMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409AbXEFJMg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 05:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933413AbXEFJMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 05:12:36 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36186 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933409AbXEFJMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 05:12:35 -0400
Message-ID: <463D9C1A.2050606@cs.helsinki.fi>
Date: Sun, 06 May 2007 12:12:58 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: Frederik Deweerdt <deweerdt@free.fr>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] do_revoke error handling (was Re: 2.6.21-mm1)
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <20070505211318.GA28912@slug> <Pine.LNX.4.64.0705060017320.21257@sbz-30.cs.Helsinki.FI> <20070505214752.GA29299@slug>
In-Reply-To: <20070505214752.GA29299@slug>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frederik Deweerdt wrote:
> diff --git a/fs/revoke.c b/fs/revoke.c
> index 1f2e3ef..86a2842 100644
> --- a/fs/revoke.c
> +++ b/fs/revoke.c
> @@ -597,6 +597,9 @@ static int do_revoke(struct inode *inode, struct file *to_exclude)
>  		goto retry;
>  	}
>  
> +	details.fset = fset;
> +	details.restore_start = 0;
> +

Looks good. Thanks!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
