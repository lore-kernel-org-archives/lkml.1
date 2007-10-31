Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbXJaHjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbXJaHjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 03:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbXJaHjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 03:39:04 -0400
Received: from cg-p07-fb.rzone.de ([81.169.146.215]:42721 "EHLO
	cg-p07-fb.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbXJaHjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 03:39:03 -0400
Date: Wed, 31 Oct 2007 08:37:19 +0100
From: Alex Riesen <raa.lkml@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org, per.liden@ericsson.com,
       allan.stephens@windriver.com
Subject: Re: tipc_config.h requires linux/string.h, which does not exist in
	exported headers
Message-ID: <20071031073719.GA3688@steel.home>
Reply-To: Alex Riesen <raa.lkml@gmail.com>
Mail-Followup-To: Alex Riesen <raa.lkml@gmail.com>,
	David Miller <davem@davemloft.net>, sam@ravnborg.org,
	linux-kernel@vger.kernel.org, per.liden@ericsson.com,
	allan.stephens@windriver.com
References: <20071030222025.GA19792@uranus.ravnborg.org> <20071030.153154.241148799.davem@davemloft.net> <20071030.211404.43558275.davem@davemloft.net> <20071030.215616.241765510.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030.215616.241765510.davem@davemloft.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-RZG-AUTH: z4gQVF2k5XWuW3CculzwpJEsD8s=
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller, Wed, Oct 31, 2007 05:56:16 +0100:
> diff --git a/include/linux/string.h b/include/linux/string.h
> index 836062b..c5d3fca 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -3,16 +3,14 @@
>  
>  /* We don't want strings.h stuff being user by user stuff by accident */
>  

While at it, could you fix this typo: "being use_d_ by user stuff by accident"?

