Return-Path: <linux-kernel-owner+w=401wt.eu-S1759771AbZFBILv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759771AbZFBILv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 04:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757144AbZFBILh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 04:11:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54502 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbZFBILg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 04:11:36 -0400
Date: Tue, 2 Jun 2009 10:11:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Alexander Potashev <aspotashev@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use KERN_INFO instead of KERN_ERR for init message
In-Reply-To: <1243891981-12118-1-git-send-email-aspotashev@gmail.com>
Message-ID: <alpine.LNX.2.00.0906021011100.7457@wotan.suse.de>
References: <1243891981-12118-1-git-send-email-aspotashev@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009, Alexander Potashev wrote:

> Signed-off-by: Alexander Potashev <aspotashev@gmail.com>
> ---
>  drivers/dca/dca-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c
> index 25b743a..e7c0b9c 100644
> --- a/drivers/dca/dca-core.c
> +++ b/drivers/dca/dca-core.c
> @@ -276,7 +276,7 @@ EXPORT_SYMBOL_GPL(dca_unregister_notify);
>  
>  static int __init dca_init(void)
>  {
> -	printk(KERN_ERR "dca service started, version %s\n", DCA_VERSION);
> +	printk(KERN_INFO "dca service started, version %s\n", DCA_VERSION);
>  	return dca_sysfs_init();
>  }

Applied, thanks Alexander.

-- 
Jiri Kosina
