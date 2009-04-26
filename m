Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbZDZSBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbZDZSBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 14:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbZDZSBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 14:01:41 -0400
Received: from netgear.net.ru ([195.178.208.66]:37749 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbZDZSBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 14:01:41 -0400
Date: Sun, 26 Apr 2009 22:01:35 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging - pohmelfs: Storage class should be before const qualifier
Message-ID: <20090426180135.GA13576@ioremap.net>
References: <1240751169-10167-1-git-send-email-tklauser@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240751169-10167-1-git-send-email-tklauser@distanz.ch>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 26, 2009 at 03:06:09PM +0200, Tobias Klauser (tklauser@distanz.ch) wrote:
> The C99 specification states in section 6.11.5:
> 
> The placement of a storage-class specifier other than at the beginning
> of the declaration specifiers in a declaration is an obsolescent
> feature.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Looks good, thank you.
Greg, please put it into the queue.

> ---
>  drivers/staging/pohmelfs/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
> index b2eaf90..779445e 100644
> --- a/drivers/staging/pohmelfs/inode.c
> +++ b/drivers/staging/pohmelfs/inode.c
> @@ -943,7 +943,7 @@ err_out_unlock:
>  	return ret;
>  }
>  
> -const static struct file_operations pohmelfs_file_ops = {
> +static const struct file_operations pohmelfs_file_ops = {
>  	.open		= generic_file_open,
>  	.fsync		= pohmelfs_fsync,
>  
> -- 
> 1.6.2.4

-- 
	Evgeniy Polyakov
