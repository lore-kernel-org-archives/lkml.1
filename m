Return-Path: <linux-kernel-owner+w=401wt.eu-S1757107AbZEUW3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107AbZEUW3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 18:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbZEUW3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 18:29:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40450
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753786AbZEUW3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 18:29:12 -0400
Date: Thu, 21 May 2009 15:29:10 -0700 (PDT)
Message-Id: <20090521.152910.256913910.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       abhijeet.kolekar@intel.com, linville@tuxdriver.com,
       reinette.chatre@intel.com
Subject: Re: linux-next: manual merge of the net tree with the tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090521.152511.171736740.davem@davemloft.net>
References: <20090521140610.551574fc.sfr@canb.auug.org.au>
	<20090521.152511.171736740.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 21 May 2009 15:25:11 -0700 (PDT)

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 21 May 2009 14:06:10 +1000
> 
>> Today's linux-next merge of the net tree got a conflict in
>> drivers/net/wireless/iwlwifi/iwl-agn.c
>> drivers/net/wireless/iwlwifi/iwl3945-base.c between commit
>> fbc9f97bbf5e1eaee562eba93dc60faaff3f3bfa ("iwlwifi: do not cancel delayed
>> work inside spin_lock_irqsave") from the wireless-current tree and commit
>> 727882d62477ed45d248e8cd6d53cf794537b073 ("iwl3945: use iwl_set_mode in
>> 3945") from the net tree.
>> 
>> I removed iwl{3945,}_set_mode() from and applied the following patch.
> 
> I'll sort this out right now, thanks Stephen.

Sorry, I misread this.  The conflict is created by the
wireless-current tree so it seems something John has to
sort out unless I've pulled that work into net-next-2.6 already.

John which is it?

Thanks.
