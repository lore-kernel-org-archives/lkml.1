Return-Path: <linux-kernel-owner+w=401wt.eu-S1758447AbXLaAB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbXLaAB2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 19:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbXLaABT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 19:01:19 -0500
Received: from slackadelic.com ([65.196.224.53]:40155 "EHLO
	mail.slackadelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712AbXLaABS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 19:01:18 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: oakad@exemail.com.au
Subject: Re: [PATCH] [MEMSTICK] Initial commit for Sony MemoryStick support
Date: Mon, 31 Dec 2007 00:01:14 +0000
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, drzeus@drzeus.cx,
       Alex Dubov <oakad@yahoo.com>
References: <1198465597-14059-1-git-send-email-oakad@exemail.com.au>
In-Reply-To: <1198465597-14059-1-git-send-email-oakad@exemail.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712310001.15395.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly just stylistic comments from me here.

On Monday 24 December 2007 03:06:37 oakad@exemail.com.au wrote:
> From: Alex Dubov <oakad@yahoo.com>
>
> Sony MemoryStick cards are used in many products manufactured by Sony. They
> are available both as storage and as IO expansion cards. Currently, only
> MemoryStick Pro storage cards are supported via TI FlashMedia MemoryStick
> interface.
>
> Signed-off-by: Alex Dubov <oakad@yahoo.com>

For MemoryStick Pro on my TI7421 card reader (since my old MemoryStick card 
and camera have disappeared somewhere, so I cannot currently test that):

Tested-by: Carlos Corbacho <carlos@strangeworlds.co.uk>

However, my only concerns are that:

1) tifm_ms was not autoloaded
2) On loading tifm_ms, only memstick was autoloaded - mspro_block was not.

Although, whether this is an issue with userspace (ie. udev) not dealing with 
the modules properly, I don't know.

> --- /dev/null
> +++ b/drivers/memstick/core/memstick.c
> @@ -0,0 +1,557 @@
> +/*
> + *  memstick.c - Sony MemoryStick support

File names in comments are now frowned upon - there was a thread on this in 
October on LKML:

http://lkml.org/lkml/2007/10/12/524

Also, before Andrew gets in with this - you should run this through 
checkpatch, as there are a few errors it throws up (mostly foo* and C99 
comments).

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
