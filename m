Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbYBXV5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbYBXV5u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 16:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYBXV5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 16:57:41 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:57475 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbYBXV5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 16:57:40 -0500
Date: Sun, 24 Feb 2008 23:56:45 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 1/3] IDE: Coding Style fixes to drivers/ide/ide-cd.c
Message-ID: <20080224215645.GE1596@cs181133002.pp.htv.fi>
References: <20080224221033.595552ce@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080224221033.595552ce@paolo-desktop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 10:10:33PM +0100, Paolo Ciarrocchi wrote:
> Before:
> total: 43 errors, 66 warnings, 2183 lines checked
> 
> After:
> total: 0 errors, 36 warnings, 2192 lines checked
> 
> I didn't (and I don't plan to) fix the warnings:
> WARNING: line over 80 characters
> 
> 
> Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
> ---
>  drivers/ide/ide-cd.c |  245 ++++++++++++++++++++++++++------------------------
>  1 files changed, 127 insertions(+), 118 deletions(-)
> 
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index 546f436..3181e71 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
>...
>  	switch (sense->sense_key) {
> -		case NO_SENSE: case RECOVERED_ERROR:
> -			break;
>...
> +	case NO_SENSE: case RECOVERED_ERROR:
> +		break;
>...

In case the goal is not to only improve the checkpatch metrics but to 
improve the readability of the code the biggest coding style problem 
here was (and still is) not the indentation.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

