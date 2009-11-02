Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbZKBVW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbZKBVW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 16:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbZKBVW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 16:22:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410AbZKBVW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 16:22:56 -0500
Message-ID: <4AEF4DAC.9080905@redhat.com>
Date: Mon, 02 Nov 2009 15:22:52 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: cmm@us.ibm.com, "Theodore Ts'o" <tytso@mit.edu>,
       Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] fs/ext4: test the i_flags field of the right structure
References: <Pine.LNX.4.64.0911022158190.4930@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0911022158190.4930@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Elsewhere, EXT4_EXTENTS_FL is combined with EXT4_I(inode)->i_flags, rather
> than inode->i_flags.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> ---
>  fs/ext4/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5c5bc5d..c0e34ab 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2787,7 +2787,7 @@ static int ext4_da_writepages_trans_blocks(struct inode *inode)
>  	 * number of contiguous block. So we will limit
>  	 * number of contiguous block to a sane value
>  	 */
> -	if (!(inode->i_flags & EXT4_EXTENTS_FL) &&
> +	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) &&
>  	    (max_blocks > EXT4_MAX_TRANS_DATA))
>  		max_blocks = EXT4_MAX_TRANS_DATA;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

