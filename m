Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbZJDVye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbZJDVye (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 17:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758125AbZJDVyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 17:54:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758123AbZJDVyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 17:54:32 -0400
Date: Sun, 4 Oct 2009 14:53:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH] connector: Provide the sender's credentials to the
 callback
Message-Id: <20091004145349.bc7b1857.akpm@linux-foundation.org>
In-Reply-To: <1254235692-1631-3-git-send-email-philipp.reisner@linbit.com>
References: <1254235692-1631-1-git-send-email-philipp.reisner@linbit.com>
	<1254235692-1631-2-git-send-email-philipp.reisner@linbit.com>
	<1254235692-1631-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 16:48:09 +0200 Philipp Reisner <philipp.reisner@linbit.com> wrote:

> Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> Acked-by: Lars Ellenberg <lars.ellenberg@linbit.com>

Please don't send unchangelogged patches.

The title tells us what the patch does, but how is the reader supposed
to work out why it does it?

> diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm-log-userspace-transfer.c
> index ba0edad..556131f 100644
> --- a/drivers/md/dm-log-userspace-transfer.c
> +++ b/drivers/md/dm-log-userspace-transfer.c
> @@ -129,7 +129,7 @@ static int fill_pkg(struct cn_msg *msg, struct dm_ulog_request *tfr)
>   * This is the connector callback that delivers data
>   * that was sent from userspace.
>   */
> -static void cn_ulog_callback(void *data)
> +static void cn_ulog_callback(void *data, struct netlink_skb_parms *nsp)
>  {
>  	struct cn_msg *msg = (struct cn_msg *)data;
>  	struct dm_ulog_request *tfr = (struct dm_ulog_request *)(msg + 1);

Your "connector/dm: Fixed a compilation warning" fix is already in
linux-next, so we throw a small and easily-fixed reject here.


