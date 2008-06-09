Return-Path: <linux-kernel-owner+w=401wt.eu-S1758652AbYFIIgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbYFIIgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 04:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbYFIIgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 04:36:45 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:43840 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbYFIIgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 04:36:44 -0400
Subject: Re: [PATCH 1/2] drivers/s390/char/tape_3590.c: introduce missing
	kfree
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Julia Lawall <julia@diku.dk>
Cc: heiko.carstens@de.ibm.com, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0806081456260.10294@ask.diku.dk>
References: <Pine.LNX.4.64.0806081456260.10294@ask.diku.dk>
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 09 Jun 2008 10:35:52 +0200
Message-Id: <1213000552.19343.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-08 at 14:56 +0200, Julia Lawall wrote:
> diff -u -p a/drivers/s390/char/tape_3590.c
> b/drivers/s390/char/tape_3590.c
> --- a/drivers/s390/char/tape_3590.c
> +++ b/drivers/s390/char/tape_3590.c
> @@ -1598,7 +1598,7 @@ tape_3590_setup_device(struct tape_devic
>         rc = tape_3590_read_dev_chars(device, rdc_data);
>         if (rc) {
>                 DBF_LH(3, "Read device characteristics failed!\n");
> -               goto fail_kmalloc;
> +               goto fail_rdc_data;
>         }
>         rc = tape_std_assign(device);
>         if (rc)
> 

Nice catch! I'll add this to the git390 queue for 2.6.26.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


