Return-Path: <linux-kernel-owner+w=401wt.eu-S1760711AbYD2Wbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760711AbYD2Wbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755779AbYD2Wb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:31:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45831
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755424AbYD2Wb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:31:26 -0400
Date: Tue, 29 Apr 2008 15:31:25 -0700 (PDT)
Message-Id: <20080429.153125.249690136.davem@davemloft.net>
To: mingo@elte.hu
Cc: tglx@linutronix.de, torvalds@linux-foundation.org,
       harvey.harrison@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bitops: remove "optimizations"
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080429142039.GD26461@elte.hu>
References: <20080429.030332.88897602.davem@davemloft.net>
	<20080429.053412.15412725.davem@davemloft.net>
	<20080429142039.GD26461@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 29 Apr 2008 16:20:39 +0200

> 
> * David Miller <davem@davemloft.net> wrote:
> 
> > Ironically, I just bisected sparc64 bootup failures to the following 
> > changeset.  It's very late here, and I haven't looked into the 
> > details, but it seems to wedge in free_area_init_nodes() on a non-NUMA 
> > system with CONFIG_NUMA disabled.
> 
> hm. I guess the next thing you plan to check is whether Thomas's patch 
> fixes it?

Yes, I just needed some sleep first, which I just obtained :-)
