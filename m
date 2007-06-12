Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbXFLMYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbXFLMYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 08:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbXFLMYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 08:24:08 -0400
Received: from pat.uio.no ([129.240.10.15]:37708 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbXFLMYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 08:24:06 -0400
Subject: Re: [-mm patch] #if 0
	mm/backing-dev.c:congestion_wait_interruptible()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Adrian Bunk <bunk@stusta.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <20070612110733.GU3588@stusta.de>
References: <20070612110733.GU3588@stusta.de>
Content-Type: text/plain
Date: Tue, 12 Jun 2007 08:23:57 -0400
Message-Id: <1181651037.6552.14.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.142)
X-UiO-Scanned: E0D0F16D1463D2F6F34CF4C6FAF60EEF7E0C1876
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 734 total 2327039 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-12 at 13:07 +0200, Adrian Bunk wrote:
> congestion_wait_interruptible() is no longer used.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Ack...

> ---
> 
>  include/linux/backing-dev.h |    1 -
>  mm/backing-dev.c            |    2 ++
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.22-rc4-mm2/include/linux/backing-dev.h.old	2007-06-12 01:21:52.000000000 +0200
> +++ linux-2.6.22-rc4-mm2/include/linux/backing-dev.h	2007-06-12 01:22:00.000000000 +0200
> @@ -93,7 +93,6 @@
>  void clear_bdi_congested(struct backing_dev_info *bdi, int rw);
>  void set_bdi_congested(struct backing_dev_info *bdi, int rw);
>  long congestion_wait(int rw, long timeout);
> -long congestion_wait_interruptible(int rw, long timeout);
>  void congestion_end(int rw);
>  
>  #define bdi_cap_writeback_dirty(bdi) \
> --- linux-2.6.22-rc4-mm2/mm/backing-dev.c.old	2007-06-12 01:22:07.000000000 +0200
> +++ linux-2.6.22-rc4-mm2/mm/backing-dev.c	2007-06-12 01:22:25.000000000 +0200
> @@ -55,6 +55,7 @@
>  }
>  EXPORT_SYMBOL(congestion_wait);
>  
> +#if 0
>  long congestion_wait_interruptible(int rw, long timeout)
>  {
>  	long ret;
> @@ -70,6 +71,7 @@
>  	return ret;
>  }
>  EXPORT_SYMBOL(congestion_wait_interruptible);
> +#endif  /*  0  */
>  
>  /**
>   * congestion_end - wake up sleepers on a congested backing_dev_info
> 

