Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab0CBMC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 07:02:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41292
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181Ab0CBMC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 07:02:57 -0500
Date: Tue, 02 Mar 2010 04:03:16 -0800 (PST)
Message-Id: <20100302.040316.155442888.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100228.230535.123985162.davem@davemloft.net>
References: <20100228.230535.123985162.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sun, 28 Feb 2010 23:05:35 -0800 (PST)

> Please pull, thanks a lot!
> 
> The following changes since commit 30ff056c42c665b9ea535d8515890857ae382540:
>   Linus Torvalds (1):
>         Merge branch 'x86-uv-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip
> 
> are available in the git repository at:
> 
>   master.kernel.org:/pub/scm/linux/kernel/git/davem/net-next-2.6.git master

Linus, if you haven't pulled in the networking tree yet, please pull
again as I just pushed the following bug fixes into there tonight.

Thanks!

The following changes since commit 47871889c601d8199c51a4086f77eebd77c29b0b:
  David S. Miller (1):
        Merge branch 'master' of /home/davem/src/GIT/linux-2.6/

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-next-2.6.git master

Eric Dumazet (1):
      net: fix protocol sk_buff field

Herton Ronaldo Krzesinski (1):
      sis190: fix cable detect via link status poll

Jiri Pirko (1):
      virtio_net: remove forgotten assignment

Sathya Perla (1):
      be2net: fix tx completion polling

Sridhar Samudrala (1):
      bridge: Fix build error when IGMP_SNOOPING is not enabled

 drivers/net/benet/be_cmds.c |   26 +++++++++++-----------
 drivers/net/benet/be_cmds.h |    2 +-
 drivers/net/benet/be_main.c |   47 +++++++++++++++++++++----------------------
 drivers/net/sis190.c        |   23 ++++++++++++++++----
 drivers/net/virtio_net.c    |    1 -
 include/linux/skbuff.h      |    2 +-
 net/bridge/br_private.h     |   14 ++++++++----
 7 files changed, 65 insertions(+), 50 deletions(-)
