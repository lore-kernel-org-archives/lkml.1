Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbXJLCVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbXJLCVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 22:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbXJLCVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 22:21:10 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:16655 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbXJLCVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 22:21:08 -0400
X-IronPort-AV: E=Sophos;i="4.21,263,1188802800"; 
   d="scan'208";a="235279450"
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [GIT PULL] please pull infiniband.git for-linus
X-Message-Flag: Warning: May contain useful information
References: <aday7e9b0m3.fsf@cisco.com>
	<20071011.181719.78707713.davem@davemloft.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 11 Oct 2007 19:21:06 -0700
In-Reply-To: <20071011.181719.78707713.davem@davemloft.net> (David Miller's message of "Thu, 11 Oct 2007 18:17:19 -0700 (PDT)")
Message-ID: <adatzoxax9p.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Oct 2007 02:21:06.0813 (UTC) FILETIME=[8B9E22D0:01C80C76]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > This will get the batch of changes queued up for the 2.6.24 merge
 > > window (although I still have a few more things to merge later, once
 > > Dave Miller's networking tree has landed too):
 > 
 > Roland are you absolutely sure this won't create merge conflicts with
 > my 8MB net-2.6 merge, inside of which there are many infiniband
 > driver changes?

I'm not absolutely sure of anything but I have merged our two git
trees quite a few times during the 2.6.23 cycle and I have not seen
any conflicts.  Unless you've added some more IB changes very recently
I don't think there should be any problem.

 > I really wish you would submit your inifiniband work through normal
 > network driver channels, such as Jeff Garzik.  Jeff has been syncing
 > on almost a daily basis with me so that I wouldn't have to worry about
 > changes coming out of left field and adding additional merge issues
 > for an already difficult merge.

I'm not sure what you mean.  During the 2.6.23 cycle I've been sending
any patches that potentially could conflict with the net-2.6 tree to
you and Jeff so that you can merge them upstream via your tree.  Or do
you mean Jeff should become the maintainer of drivers/infiniband??

Can't you guys just keep the networking stuff contained in its little
box so it doesn't create maintenance problems for InfiniBand stuff?

 > Even if you're confident there won't be merge issues, could you just
 > wait for the net-2.6 stuff to go in first?

I don't mind waiting but I guess it's up to Linus really.

 - R.
