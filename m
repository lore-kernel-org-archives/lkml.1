Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbXJ2Wlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbXJ2Wlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbXJ2Wlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:41:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56102
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752430AbXJ2Wli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:41:38 -0400
Date: Mon, 29 Oct 2007 15:41:39 -0700 (PDT)
Message-Id: <20071029.154139.19375144.davem@davemloft.net>
To: jengelh@computergmbh.de
Cc: toms@wonderland.us.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: drivers/net/sunhme.c patch
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0710292311070.32301@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710291606260.26070@fbirervta.pbzchgretzou.qr>
	<20071029.151025.87460351.davem@davemloft.net>
	<Pine.LNX.4.64.0710292311070.32301@fbirervta.pbzchgretzou.qr>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Mon, 29 Oct 2007 23:12:25 +0100 (CET)

> The question was more like: if I put in a QFE (that was acquired together
> with a SUN E250) into x86, would I get duplicate MACs? (Would be strange -
> I would have supposed the OF on the card is independent.)

You are not supposed to.  Each HME instance should get a unique
MAC.

Normally OF would propagate this information around to the independant
device nodes, and we should try to preserve this behavior for non-OF
systems.
