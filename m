Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbYKPUth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbYKPUth (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 15:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbYKPUtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 15:49:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37596
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752100AbYKPUtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 15:49:25 -0500
Date: Sun, 16 Nov 2008 12:49:24 -0800 (PST)
Message-Id: <20081116.124924.146154114.davem@davemloft.net>
To: jdb@comx.dk
Cc: miltonm@bga.com, segher@kernel.crashing.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, bhutchings@solarflare.com
Subject: Re: [PATCH] niu: bitwise or does not imply ordering
From: David Miller <davem@davemloft.net>
In-Reply-To: <1226849525.8189.6.camel@localhost.localdomain>
References: <312268717986b8b45674.846930886.miltonm@bga.com>
	<1226849525.8189.6.camel@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Dangaard Brouer <jdb@comx.dk>
Date: Sun, 16 Nov 2008 16:32:05 +0100

> 
> I have tested it on the actual hardware, it works...
> 
> I actually agree that we should make it explicit, eventhough DaveM seems
> to disagree on the netdev list.

I'm also not applying this patch for another reason.

This is a knee-jerk reaction patch, purely.  This person
saw the commit and wants to fix only _THIS_ case.

Well guess what?  If you really CARED, you'd go change this
across the whole tree.  This exact construct exists ALL
OVER the kernel.  In fact there are sequences that match
this new NIU code exactly.

Did these people complaining look for those?  No.
