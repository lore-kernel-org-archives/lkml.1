Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbXGaVHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbXGaVHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbXGaVHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:07:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51253
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751619AbXGaVH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:07:29 -0400
Date: Tue, 31 Jul 2007 14:07:28 -0700 (PDT)
Message-Id: <20070731.140728.118970012.davem@davemloft.net>
To: m.kozlowski@tuxland.pl
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 39] net/ipv4/ip_options.c: kmalloc + memset conversion
 to kzalloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <200707312016.59970.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	<200707312016.59970.m.kozlowski@tuxland.pl>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date: Tue, 31 Jul 2007 20:16:59 +0200

> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Applied, but note that this patch changes behavior, previously
only the ip_options structure base was cleared out, but now
the whole memory region is cleared.

I think it's OK for this case, but I'm just making note of it.
