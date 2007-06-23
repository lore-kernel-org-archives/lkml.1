Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbXFWSJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbXFWSJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 14:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbXFWSJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 14:09:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34409 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752951AbXFWSJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 14:09:22 -0400
Date: Sat, 23 Jun 2007 11:06:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: spock@gentoo.org
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 2/4] fbdev: add connector entries for uvesafb
Message-Id: <20070623110627.c911373c.akpm@linux-foundation.org>
In-Reply-To: <20070623105146.GC12623@spock.one.pl>
References: <20070623105146.GC12623@spock.one.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 12:51:46 +0200 Michal Januszewski <spock@gentoo.org> wrote:

> Add connector's idx and val constants for v86d and uvesafb.
> 
> Also change the maximum message size to 4k to allow transfers of VBE
> data blocks from userspace.
> 
> Signed-off-by: Michal Januszewski <spock@gentoo.org>
> ---
> include/linux/connector.h |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/connector.h b/include/linux/connector.h
> index 10eb56b..46b2aba 100644
> --- a/include/linux/connector.h
> +++ b/include/linux/connector.h
> @@ -36,14 +36,15 @@
>  #define CN_VAL_CIFS                     0x1
>  #define CN_W1_IDX			0x3	/* w1 communication */
>  #define CN_W1_VAL			0x1
> +#define CN_IDX_V86D			0x4
> +#define CN_VAL_V86D_UVESAFB		0x1
>  
> -
> -#define CN_NETLINK_USERS		4
> +#define CN_NETLINK_USERS		5
>  
>  /*
>   * Maximum connector's message size.
>   */
> -#define CONNECTOR_MAX_MSG_SIZE 	1024
> +#define CONNECTOR_MAX_MSG_SIZE 	4096
>  
>  /*
>   * idx and val are unique identifiers which 
> 
> 

Evgeniy, could you please review this?

The need to add these enumerations for unrelated subsystems to connector.h
may get a bit ugly as time passes, but I guess it's OK for now.
