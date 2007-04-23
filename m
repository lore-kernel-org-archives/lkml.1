Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbXDWOkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbXDWOkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 10:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXDWOkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 10:40:46 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:59074
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbXDWOkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 10:40:45 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 9/9] Kconfig: broadcom 4400 dependency.
Date: Mon, 23 Apr 2007 16:39:43 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       akpm@linux-foundation.org, linville@tuxdriver.com, arnd@arndb.de,
       maxextreme@gmail.com, gregkh@suse.de
References: <20070423141427.GJ21174@skybase>
In-Reply-To: <20070423141427.GJ21174@skybase>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704231639.43592.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2007 16:14, Martin Schwidefsky wrote:
> [PATCH 9/9] Kconfig: broadcom 4400 dependency.
> 
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Add HAS_IOMEM dependency to the B44 "Broadcom 4400 ethernet support"
> config option. This hides the option for s390.
> Goes on top of git-wireless.patch.
> 
> Cc: Michael Buesch <mb@bu3sch.de>
> Cc: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

Acked-by: Michael Buesch <mb@bu3sch.de>

> ---
> 
>  drivers/net/Kconfig |    1 +
>  1 files changed, 1 insertion(+)
> 
> diff -urpN linux-2.6/drivers/net/Kconfig linux-2.6-patched/drivers/net/Kconfig
> --- linux-2.6/drivers/net/Kconfig	2007-04-23 15:51:44.000000000 +0200
> +++ linux-2.6-patched/drivers/net/Kconfig	2007-04-23 15:53:16.000000000 +0200
> @@ -1432,6 +1432,7 @@ config APRICOT
>  
>  config B44
>  	tristate "Broadcom 4400 ethernet support"
> +	depends on HAS_IOMEM
>  	select SSB
>  	select MII
>  	help
> 
> 

-- 
Greetings Michael.
