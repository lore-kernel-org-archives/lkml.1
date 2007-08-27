Return-Path: <linux-kernel-owner+w=401wt.eu-S1762653AbXH0We3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762653AbXH0We3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757609AbXH0WeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:34:21 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:51726 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbXH0WeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 18:34:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pnsPlkjAhNlMe6E/Twq4va6V47WxtTNNpI4nvlxHsD5aX+vMtO5tR1VEYE+Uhj6vlZLTZG+Tj9ZxXH7dH5FAoYQh3SzicnsQMGGMsAA9DaTc9PqwM5aa3opefYopEG4paipCoVliD1Hx4EtZSLCEohW6VzZUXmvNA+9cXfzjJoQ=
Message-ID: <1ba2fa240708271534s670af1e7u6cb8a0d7cc2a7c9a@mail.gmail.com>
Date: Tue, 28 Aug 2007 01:34:18 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [-mm patch] iwl-base.c bugfixes
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20070827212934.GI26410@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	 <20070827212934.GI26410@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/07, Adrian Bunk <bunk@kernel.org> wrote:
> On Wed, Aug 22, 2007 at 02:06:48AM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.23-rc2-mm2:
> >...
> >  git-wireless.patch
> >...
> >  git trees
> >...
>
> This patch fixes two obvious bugs.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
>
>  drivers/net/wireless/iwl-base.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> 600ffdc11b25ac0aee15271d1b2ce99a367efa31
> diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
> index b8293fe..f65c30e 100644
> --- a/drivers/net/wireless/iwl-base.c
> +++ b/drivers/net/wireless/iwl-base.c
> @@ -343,7 +343,7 @@ int iwl_tx_queue_init(struct iwl_priv *priv,
>          * command is very huge the system will not have two scan at the
>          * same time */
>         len = sizeof(struct iwl_cmd) * slots_num;
> -       if (txq_id == IWL_CMD_QUEUE_NUM);
> +       if (txq_id == IWL_CMD_QUEUE_NUM)
>                 len +=  IWL_MAX_SCAN_SIZE;
>         txq->cmd = pci_alloc_consistent(dev, len, &txq->dma_addr_cmd);
>         if (!txq->cmd)
> @@ -390,7 +390,7 @@ void iwl_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq)
>                 iwl_hw_txq_free_tfd(priv, txq);
>
>         len = sizeof(struct iwl_cmd) * q->n_window;
> -       if (q->id == IWL_CMD_QUEUE_NUM);
> +       if (q->id == IWL_CMD_QUEUE_NUM)
>                 len += IWL_MAX_SCAN_SIZE;
>
>         pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
>
>
Shame on me.
Thanks
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
