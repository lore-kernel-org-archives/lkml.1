Return-Path: <linux-kernel-owner+w=401wt.eu-S1759639AbXLMAuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639AbXLMAuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 19:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXLMAud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 19:50:33 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:34179 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbXLMAuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 19:50:32 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Thu, 13 Dec 2007 01:48:22 +0100
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux@bohmer.net, jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com, mbuesch@freenet.de
References: <20071213003028.676998182@mvista.com> <20071213003032.547362071@mvista.com>
In-Reply-To: <20071213003032.547362071@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712130148.22727.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 December 2007 09:00:03 Daniel Walker wrote:
> 
> Signed-Off-By: Daniel Walker <dwalker@mvista.com>
> 
> ---
>  drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c |   30 ++++++++++++-------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
> 
> Index: linux-2.6.23/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c
> ===================================================================
> --- linux-2.6.23.orig/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c
> +++ linux-2.6.23/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c
> @@ -43,7 +43,7 @@
>  
>  static struct bcm43xx_debugfs fs;
>  static char really_big_buffer[REALLY_BIG_BUFFER_SIZE];
> -static DECLARE_MUTEX(big_buffer_sem);
> +static DEFINE_MUTEX(big_buffer_mutex);

This driver is scheduled for removal, so I'd not touch it anymore
to avoid the possibility to introduce a lastminute regression.
The new drivers (b43 and b43legacy) have this fixed (in a different
way by completely removing it).

-- 
Greetings Michael.
