Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbZFAF6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbZFAF6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 01:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbZFAF6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 01:58:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:49295 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbZFAF6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 01:58:34 -0400
Subject: Re: [RESEND][PATCH 2/2 -tip] headers_check fix: linux/net_dropmon.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1242795467.3260.8.camel@localhost.localdomain>
References: <1242795274.3260.4.camel@localhost.localdomain>
	 <1242795467.3260.8.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 11:20:40 +0530
Message-Id: <1243835440.3170.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-20 at 10:27 +0530, Jaswinder Singh Rajput wrote:
> fix the following 'make headers_check' warnings:
> 
>   usr/include/linux/net_dropmon.h:7: found __[us]{8,16,32,64} type without #include <linux/types.h>
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  include/linux/net_dropmon.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/net_dropmon.h b/include/linux/net_dropmon.h
> index 0217fb8..0e2e100 100644
> --- a/include/linux/net_dropmon.h
> +++ b/include/linux/net_dropmon.h
> @@ -1,6 +1,7 @@
>  #ifndef __NET_DROPMON_H
>  #define __NET_DROPMON_H
>  
> +#include <linux/types.h>
>  #include <linux/netlink.h>
>  
>  struct net_dm_drop_point {

