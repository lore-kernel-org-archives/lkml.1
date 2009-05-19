Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbZESEJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbZESEJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 00:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbZESEJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 00:09:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46700
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734AbZESEJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 00:09:15 -0400
Date: Mon, 18 May 2009 21:09:13 -0700 (PDT)
Message-Id: <20090518.210913.206585156.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       vasu.dev@intel.com, jeykholt@cisco.com, robert.w.love@intel.com,
       James.Bottomley@HansenPartnership.com, christopher.leech@intel.com
Subject: Re: linux-next: manual merge of the net tree with Linus' tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090519133958.31ec120b.sfr@canb.auug.org.au>
References: <20090519133958.31ec120b.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 19 May 2009 13:39:58 +1000

> Today's linux-next merge of the net tree got a conflict in
> drivers/scsi/fcoe/fcoe.c between commit
> 6401bdcad536cc00589c38e7e1c140d3acc00087 ("[SCSI] fcoe: fip: add
> multicast filter to receive FIP advertisements") from Linus' tree and
> commit 184dd3459bb334d9061b58faed3610d08d6c7ff8 ("fcoe: adds spma mode
> support") from the net tree.
> 
> There is another trivial conflict between commit
> dd3fd72e692c8af007f70df4433c0cffe8582d8b ("[SCSI] fcoe: fix spelling
> typos and bad comments") from Linus' tree and commit
> ab6b85c1d7a1bf6c2b27fb542a7b2404e45b7e24 ("fcoe: consolidates netdev
> related config and cleanup for spma mode") from the net tree.
> 
> Just context changes.  I fixed them up (see below) and can carry them for
> a while.

I'll pull net-2.6 into net-next-2.6 and push the result to kernel.org
to resolve this.

Thanks!
