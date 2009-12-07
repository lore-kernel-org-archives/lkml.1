Return-Path: <linux-kernel-owner+w=401wt.eu-S935161AbZLGODe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935161AbZLGODe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 09:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935150AbZLGODc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 09:03:32 -0500
Received: from mtagate7.de.ibm.com ([195.212.17.167]:32837 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935126AbZLGODc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 09:03:32 -0500
Date: Mon, 7 Dec 2009 15:03:42 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty: PTR_ERR return of wrong pointer in fs3270_open()
Message-ID: <20091207150342.23a6cb66@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <4B1D0433.3080506@gmail.com>
References: <4B1D0433.3080506@gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Dec 2009 14:33:39 +0100
Roel Kluin <roel.kluin@gmail.com> wrote:

> Return the PTR_ERR of the correct pointer.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/s390/char/fs3270.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/s390/char/fs3270.c b/drivers/s390/char/fs3270.c
> index 097d384..2ae58d0 100644
> --- a/drivers/s390/char/fs3270.c
> +++ b/drivers/s390/char/fs3270.c
> @@ -465,7 +465,7 @@ fs3270_open(struct inode *inode, struct file *filp)
>  	if (IS_ERR(ib)) {
>  		raw3270_put_view(&fp->view);
>  		raw3270_del_view(&fp->view);
> -		rc = PTR_ERR(fp);
> +		rc = PTR_ERR(ib);
>  		goto out;
>  	}
>  	fp->rdbuf = ib;

And added this one as well.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

