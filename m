Return-Path: <linux-kernel-owner+w=401wt.eu-S1767391AbXECFFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767391AbXECFFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 01:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767392AbXECFFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 01:05:49 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:12868 "EHLO
	asav14.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767391AbXECFFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 01:05:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAGQKOUZKhRO4W2dsb2JhbACBZI4lHQ0GEA
From: Dmitry Torokhov <dtor@insightbb.com>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [patch] pull in the linux/input.h header in linux/uinput.h
Date: Thu, 3 May 2007 01:05:46 -0400
User-Agent: KMail/1.9.3
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <200705021849.35729.vapier@gentoo.org>
In-Reply-To: <200705021849.35729.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705030105.47204.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 May 2007 18:49, Mike Frysinger wrote:
> uinput.h relies on structures only found in input.h, so pull in the header
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> diff --git a/include/linux/uinput.h b/include/linux/uinput.h
> index 1fd61ee..a6c1e8e 100644
> --- a/include/linux/uinput.h
> +++ b/include/linux/uinput.h
> @@ -32,6 +32,8 @@
>   *		- first public version
>   */
>  
> +#include <linux/input.h>
> +
>  #define UINPUT_VERSION		3
>  
>  #ifdef __KERNEL__
> 

Applied, thank you.

-- 
Dmitry
