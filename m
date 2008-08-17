Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbYHQSNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbYHQSNX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 14:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYHQSNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 14:13:13 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2695 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbYHQSNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 14:13:13 -0400
Subject: Re: [PATCH 3/5] ide: add a driver-wide debugging macro
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Bartlomiej@gollum.tnic, Zolnierkiewicz@gollum.tnic, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
In-Reply-To: <1218993826-4571-4-git-send-email-petkovbb@gmail.com>
References: <1218993826-4571-1-git-send-email-petkovbb@gmail.com>
	 <1218993826-4571-4-git-send-email-petkovbb@gmail.com>
Content-Type: text/plain
Date: Sun, 17 Aug 2008 11:13:06 -0700
Message-Id: <1218996786.24527.115.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.3mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-17 at 19:23 +0200, Borislav Petkov wrote:
> diff --git a/include/linux/ide.h b/include/linux/ide.h
> index c161840..b6d714d 100644
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h
> []
> +/* DRV_NAME has to be defined in the driver before using the macro below */
> +#define __ide_debug_log(lvl, fmt, args...)			\
> +{								\
> +	if (unlikely(drive->debug_mask & lvl))			\
> +		printk(KERN_INFO DRV_NAME ": " fmt, ## args);	\
> +}

Shouldn't a debug printk use KERN_DEBUG?

