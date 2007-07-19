Return-Path: <linux-kernel-owner+w=401wt.eu-S933913AbXGSWUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbXGSWUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 18:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762987AbXGSWUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 18:20:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39410 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761985AbXGSWUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 18:20:44 -0400
Date: Thu, 19 Jul 2007 15:20:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jirislaby@gmail.com
Subject: Re: [PATCH] Warn userspace about including an empty linux/tty.h.
Message-Id: <20070719152035.1cb98525.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707190721520.25369@localhost.localdomain>
References: <Pine.LNX.4.64.0707190721520.25369@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 07:23:46 -0400 (EDT)
"Robert P. J. Day" <rpjday@mindspring.com> wrote:

> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
>   what subsystem would something like this belong to?
> 
> 
> diff --git a/include/linux/tty.h b/include/linux/tty.h
> index 691a174..fd67da8 100644
> --- a/include/linux/tty.h
> +++ b/include/linux/tty.h
> @@ -5,6 +5,10 @@
>   * 'tty.h' defines some structures used by tty_io.c and some defines.
>   */
> 
> +#ifndef __KERNEL__
> +#warning "Please don't include this file from userspace, it's empty."
> +#endif
> +

this seems pointless?
