Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZI3LU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZI3LU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 07:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZI3LUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 07:20:55 -0400
Received: from netgear.net.ru ([195.178.208.66]:57648 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbZI3LUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 07:20:54 -0400
Date: Wed, 30 Sep 2009 15:20:57 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       Andrew Morton <akpm@linux-foundation.com>
Subject: Re: [PATCH] connector: Allow permission checking in the receiver callbacks
Message-ID: <20090930112057.GA15150@ioremap.net>
References: <1254235692-1631-1-git-send-email-philipp.reisner@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254235692-1631-1-git-send-email-philipp.reisner@linbit.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp.

On Tue, Sep 29, 2009 at 04:48:07PM +0200, Philipp Reisner (philipp.reisner@linbit.com) wrote:
> Various users of the connector should actually check if the
> sender's capabilities of a netlink/connector packet are
> actually sufficient for the operation they trigger. Up to
> now the connector framework did not allow the kernel side
> receiver to do so.
> 
> This patch set does the groundwork.
> 
> Philipp Reisner (4):
>   connector: Keep the skb in cn_callback_data
>   connector: Provide the sender's credentials to the callback
>   connector/dm: Fixed a compilation warning
>   connector: Removed the destruct_data callback since it is always
>     kfree_skb()

Patches look good to me.
Andrew please apply to the appropriate tree. I do not know whether it is
acceptible now, since it is not a bugfix, but merely a simple cleanup.
Feel free to add my signed off or ack, thank you.

>  Documentation/connector/cn_test.c      |    2 +-
>  Documentation/connector/connector.txt  |    8 ++++----
>  drivers/connector/cn_queue.c           |   12 +++++++-----
>  drivers/connector/connector.c          |   22 ++++++++--------------
>  drivers/md/dm-log-userspace-transfer.c |    3 +--
>  drivers/staging/dst/dcore.c            |    2 +-
>  drivers/staging/pohmelfs/config.c      |    2 +-
>  drivers/video/uvesafb.c                |    2 +-
>  drivers/w1/w1_netlink.c                |    2 +-
>  include/linux/connector.h              |   11 ++++-------
>  10 files changed, 29 insertions(+), 37 deletions(-)

-- 
	Evgeniy Polyakov
