Return-Path: <linux-kernel-owner+w=401wt.eu-S1760075AbZJHUvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075AbZJHUvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 16:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759781AbZJHUu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 16:50:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44788 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759740AbZJHUu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 16:50:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH suspend-2.6#linux-next] PM / freezer: add missing include
Date: Thu, 8 Oct 2009 22:51:48 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091008153051.37f043fa.sfr@canb.auug.org.au> <4ACDAF18.2030705@kernel.org>
In-Reply-To: <4ACDAF18.2030705@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910082251.48381.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 October 2009, Tejun Heo wrote:
> Fix compile failure caused by a48145a7cbf3b0555ba3ad61aaf2c38719bab95d
> forgetting to include delay.h.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>

I folded it into the original patch and pushed the updated tree.

Thanks,
Rafael


> ---
>  kernel/power/process.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index 66161f0..5ade1bd 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -14,6 +14,7 @@
>  #include <linux/module.h>
>  #include <linux/syscalls.h>
>  #include <linux/freezer.h>
> +#include <linux/delay.h>
>  
>  /* 
>   * Timeout for stopping processes
> 
> 

