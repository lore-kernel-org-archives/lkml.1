Return-Path: <linux-kernel-owner+w=401wt.eu-S1758118AbZFJIM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118AbZFJIM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 04:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757945AbZFJIL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 04:11:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50051
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757911AbZFJILx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 04:11:53 -0400
Date: Wed, 10 Jun 2009 01:11:55 -0700 (PDT)
Message-Id: <20090610.011155.231596832.davem@davemloft.net>
To: hawk@comx.dk
Cc: paulmck@linux.vnet.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, urs.thuermann@volkswagen.de,
       oliver.hartkopp@volkswagen.de, wg@grandegger.com,
       vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org,
       Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org,
       netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 0/5] We must use rcu_barrier() on module unload
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090608130959.10052.54590.stgit@localhost>
References: <20090608130959.10052.54590.stgit@localhost>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Dangaard Brouer <hawk@comx.dk>
Date: Mon, 08 Jun 2009 15:11:23 +0200

> If an unloadable module uses RCU callbacks, it need to use
> rcu_barrier() so that the module may be safely unloaded.
 ...
> The patchset is made on top of DaveM's net-next-2.6 tree (starting on
> top of commit a1c1db392090). As this is my usual development tree,
> even though this patchset is bugfixes. (Just tested it applied cleanly
> on Linus'es tree ...)

All 5 patches applied, thanks!
