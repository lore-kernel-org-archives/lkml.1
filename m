Return-Path: <linux-kernel-owner+w=401wt.eu-S1759469AbYA0ThN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbYA0ThN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757122AbYA0Tcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:32:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:9237 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbYA0TcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:32:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=QU0K4W3jYZZhWSm6GWzjJ3fOekcJpnjpSQ7VF6HHDNMvpy6XNG0rdIDMFznX/QpZANnOF8ix0+6E1Z4ZTSXwwPdOJ6OfIxhoXm+/VSRsmEcOvor9kltWZIXHIywmKf1BAW/t2SU20aXs1ub9cTYmE5tneVz4KD+dUSVjQM9tgtA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 21/32] ide-tape: idetape_chrdev_direction_t:shorten enum names
Date: Sun, 27 Jan 2008 19:38:18 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com> <1201427300-3954-16-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1201427300-3954-16-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801271938.18520.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008, Borislav Petkov wrote:
> From: Borislav Petkov <bbpetkov@yahoo.de>
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> ---
>  drivers/ide/ide-tape.c |   60 ++++++++++++++++++++++++-----------------------
>  1 files changed, 31 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index cf308d7..b487d56 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -178,11 +178,13 @@ enum {
>  /*
>   *	For general magnetic tape device compatibility.
>   */
> +
> +/* tape directions */
>  typedef enum {
> -	idetape_direction_none,
> -	idetape_direction_read,
> -	idetape_direction_write
> -} idetape_chrdev_direction_t;
> +	idetape_dir_none,
> +	idetape_dir_read,
> +	idetape_dir_write

Could you convert them to upper-case while at it?

> +} idetape_chrdev_dir_t;
