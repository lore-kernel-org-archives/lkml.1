Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbZJHIhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbZJHIhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 04:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755393AbZJHIho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 04:37:44 -0400
Received: from mail-qy0-f186.google.com ([209.85.221.186]:61939 "EHLO
	mail-qy0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbZJHIhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 04:37:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=G+LPg+QU3LSTVBZxstTr61dHv0GDimdfy0INZhpY9R+M41k04ahICnbF8BfZEZpVSS
         I9zGXTsoFJEB4bOguUpbpEHn9RRUOfSjhyPE8xhsx0Hyq+u8ldCimowHebk3SCnejl33
         pXLk2xe/Lqv9hhS/vBMZJNvEE8kY5lniVLXSY=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Oskar Schirmer <os@emlix.com>
Subject: Re: [PATCH] add missing include in lib/rational.c
References: <20091008075403.GE30719@pengutronix.de>
Date: Thu, 08 Oct 2009 16:39:37 +0800
In-Reply-To: <20091008075403.GE30719@pengutronix.de> (Sascha Hauer's message
	of "Thu, 8 Oct 2009 09:54:03 +0200")
Message-ID: <87iqeqp9di.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sascha Hauer <s.hauer@pengutronix.de> writes:

> Hi,
>
> Here is a little patch to fix a compiler warning
>
> fixes:
>
> lib/rational.c:62: warning: data definition has no type or storage class
> lib/rational.c:62: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
> lib/rational.c:62: warning: parameter names (without types) in function declaration
>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

> ---
>  lib/rational.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/lib/rational.c b/lib/rational.c
> index b3c099b..3ed247b 100644
> --- a/lib/rational.c
> +++ b/lib/rational.c
> @@ -7,6 +7,7 @@
>   */
>  
>  #include <linux/rational.h>
> +#include <linux/module.h>
>  
>  /*
>   * calculate best rational approximation for a given fraction
> -- 
> 1.6.4.3
