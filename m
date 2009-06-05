Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbZFESAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbZFESAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756619AbZFESAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:00:38 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:4704 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503AbZFESAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:00:36 -0400
X-IronPort-AV: E=Sophos;i="4.41,312,1241395200"; 
   d="scan'208";a="167644975"
Date: Fri, 5 Jun 2009 11:00:38 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, greg@kroah.com, linux-scsi@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] initdev:kernel: Asynchronously-discovered device
	synchronization, v5
Message-ID: <20090605180038.GC18688@cuplxvomd02.corp.sa.net>
References: <20090504074522.13f1ed77@infradead.org> <Pine.LNX.4.44L0.0905041100500.3092-100000@iolanthe.rowland.org> <20090505234725.5ab247db@linux-lm> <d82e647a0905050853q4a1d5066ib71411cbef186c45@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d82e647a0905050853q4a1d5066ib71411cbef186c45@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-2; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 11:53:38AM -0400, Ming Lei wrote:
> 2009/5/5 Ming Lei <tom.leiming@gmail.com>:

> Also need all block device drivers use initdev_*, much work to do,:-)

Not directly. All interesting block devices funnel through just a few functions
to make the block device usable. I think I have the right place for the
initdev_registered() call, but I definitely need feedback on this.

> Lei Ming

David VomLehn
