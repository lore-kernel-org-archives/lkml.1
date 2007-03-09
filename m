Return-Path: <linux-kernel-owner+w=401wt.eu-S2992996AbXCIGV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992996AbXCIGV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 01:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992995AbXCIGV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 01:21:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38205
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2992993AbXCIGV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 01:21:58 -0500
Date: Thu, 08 Mar 2007 22:21:54 -0800 (PST)
Message-Id: <20070308.222154.74746753.davem@davemloft.net>
To: peter.p.waskiewicz.jr@intel.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       christopher.leech@intel.com
Subject: Re: [PATCH 0/2] NET: Multiple queue network device support REPOST
From: David Miller <davem@davemloft.net>
In-Reply-To: <1173420779298-git-send-email-peter.p.waskiewicz.jr@intel.com>
References: <1173420779298-git-send-email-peter.p.waskiewicz.jr@intel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


You didn't address my correction the other day wherein I clarified
for you that my idea was not to store the queue mapping in
skb->priority but rather to shrink skb->priority to a u16 and
add a new u16 skb->queue_mapping or whatever field to store the
necessary information.

You're just posting a set of patches using the same approach again
plus some bug fixes, so there is essentially nothing new for anyone to
review.

Why ask for feedback if you fail to take any of it into consideration?
:-/
