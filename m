Return-Path: <linux-kernel-owner+w=401wt.eu-S1758372AbXGVCMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372AbXGVCMd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 22:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbXGVCMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 22:12:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52321
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753715AbXGVCMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 22:12:24 -0400
Date: Sat, 21 Jul 2007 19:12:23 -0700 (PDT)
Message-Id: <20070721.191223.15264470.davem@davemloft.net>
To: jengelh@computergmbh.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] CONFIG_NET=n - lots of link time errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0707211817490.21737@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707211817490.21737@fbirervta.pbzchgretzou.qr>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Sat, 21 Jul 2007 18:27:38 +0200 (CEST)

> Enabling drivers from "Devices > Networking" (in menuconfig), for 
> example SLIP and/or PLIP, throws link time errors when CONFIG_NET itself 
> is =n. Have CONFIG_NETDEVICES depend on CONFIG_NET.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

This is the second time I've seen this change in the past few
days, and people seem to hit it quite readily with randconfig.

It seems reasonable and I'll apply it, thanks Jan.
