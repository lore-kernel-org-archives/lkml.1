Return-Path: <linux-kernel-owner+w=401wt.eu-S1759404AbXJNTTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbXJNTTy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 15:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbXJNTTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 15:19:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38646 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751279AbXJNTTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 15:19:45 -0400
Date: Sun, 14 Oct 2007 12:19:19 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, jgarzik@pobox.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove duplicate initializer (macvlan)
Message-ID: <20071014121920.78677860@freepuppy.rosehill>
In-Reply-To: <20071014182259.GY8181@ftp.linux.org.uk>
References: <20071014182259.GY8181@ftp.linux.org.uk>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Oct 2007 19:22:59 +0100
Al Viro <viro@ftp.linux.org.uk> wrote:

> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/net/macvlan.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
> index b7c81c8..2e4bcd5 100644
> --- a/drivers/net/macvlan.c
> +++ b/drivers/net/macvlan.c
> @@ -178,7 +178,6 @@ static const struct header_ops macvlan_hard_header_ops = {
>  	.create  	= macvlan_hard_header,
>  	.rebuild	= eth_rebuild_header,
>  	.parse		= eth_header_parse,
> -	.rebuild	= eth_rebuild_header,
>  	.cache		= eth_header_cache,
>  	.cache_update	= eth_header_cache_update,
>  };

Yup, thanks Al

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
