Return-Path: <linux-kernel-owner+w=401wt.eu-S933728AbXIBSEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728AbXIBSEu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 14:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbXIBSEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 14:04:22 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:49606 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbXIBSEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 14:04:21 -0400
Date: Sun, 2 Sep 2007 20:04:09 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Stephen Hemminger <shemminger@linux-foundation.org>
cc: Christian Kujau <lists@nerdbynature.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: RTNL: assertion failed at net/core/dev.c
In-Reply-To: <20070902171300.2f4814d1@oldman>
Message-ID: <alpine.DEB.0.999.0709022003110.7103@sheep.housecafe.de>
References: <alpine.DEB.0.999.0709021754290.7103@sheep.housecafe.de>
 <20070902171300.2f4814d1@oldman>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Sep 2007, Stephen Hemminger wrote:
> Vendor module calls kernel api incorrectly. dev_set_promiscuity requires
> that the calling thread hold rtnl mutex (ie call rtnl_lock). It's their bug,
> netdev doesn't want to hear about it.

OK, that's all I needed to know. Thank you both for your comments!

Christian.
-- 
BOFH excuse #435:

Internet shut down due to maintenance
