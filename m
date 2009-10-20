Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbZJTChP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbZJTChP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 22:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbZJTChL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 22:37:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51878
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758251AbZJTChH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 22:37:07 -0400
Date: Mon, 19 Oct 2009 19:37:29 -0700 (PDT)
Message-Id: <20091019.193729.102016721.davem@davemloft.net>
To: hidave.darkstar@gmail.com
Cc: marcel@holtmann.org, oliver@hartkopp.net, netdev@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] bluetooth: static lock key fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091019062830.GB4102@darkstar.vlan7>
References: <20091019062830.GB4102@darkstar.vlan7>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>
Date: Mon, 19 Oct 2009 14:28:30 +0800

> When shutdown ppp connection, lockdep waring about non-static key
> will happen, it is caused by the lock is not initialized properly
> at that time.
> 
> Fix with tuning the lock/skb_queue_head init order
 ...
> Reported-by: Oliver Hartkopp <oliver@hartkopp.net>
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> Tested-by: Oliver Hartkopp <oliver@hartkopp.net>

Applied, thanks Dave.
