Return-Path: <linux-kernel-owner+w=401wt.eu-S933305AbYGQViO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305AbYGQViO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932232AbYGQVhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:37:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51178
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754661AbYGQVhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:37:54 -0400
Date: Thu, 17 Jul 2008 14:37:53 -0700 (PDT)
Message-Id: <20080717.143753.250293973.davem@davemloft.net>
To: m.kozlowski@tuxland.pl
Cc: jie.yang@atheros.com, jeff@garzik.org, yjwei@cn.fujitsu.com,
       rdreier@cisco.com, shemminger@vyatta.com, jcliburn@gmail.com,
       parag.warudkar@gmail.com, w@1wt.eu, oliver.schuster@schweigstill.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] atl1e: Atheros L1E Gigabit Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <200807172204.15342.m.kozlowski@tuxland.pl>
References: <12162854952457-git-send-email-jie.yang@atheros.com>
	<200807172204.15342.m.kozlowski@tuxland.pl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date: Thu, 17 Jul 2008 22:04:14 +0200

> Hello,
> 
> > +#define SPEED_0		   0xffff
> > +#define SPEED_10           10
> > +#define SPEED_100          100
> > +#define SPEED_100          100
> 
> Small thing - double define for SPEED_100.
> 
> > +#define SPEED_1000         1000

And these are all entirely superfluous, since they are already defined
in linux/ethtool.h
