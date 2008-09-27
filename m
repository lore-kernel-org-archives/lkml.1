Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbYI0Voh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbYI0Voh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 17:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbYI0Vo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 17:44:29 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:42646 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753362AbYI0Vo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 17:44:28 -0400
Date: Sat, 27 Sep 2008 23:44:24 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Lin Tan <tammy000@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH git latest] drivers/net: fixing a datarace related to
	update_stats()
Message-ID: <20080927214424.GA12865@electric-eye.fr.zoreil.com>
References: <20080926023322.GA16514@carmen.cs.uiuc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080926023322.GA16514@carmen.cs.uiuc.edu>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please Cc: netdev@vger.kernel.org)

Lin Tan <tammy000@gmail.com> :
[drivers/net/pcmcia/3c589_cs.c race]
> As indicated by the following comment, a lock must be held before calling 
> function update_stats(). This rule is followed in some cases, but not in 
> others. For example, the lock is held when the function is called in function 
> el3_get_stats(), but the lock is NOT held when called in el3_close(). It can 
> cause potential data races. 

I would not bet that the irq handler does not race with el3_close()
in the first place. Could you dig it ?

-- 
Ueimor
