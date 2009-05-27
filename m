Return-Path: <linux-kernel-owner+w=401wt.eu-S1760654AbZE0UzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760654AbZE0UzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759071AbZE0UzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:55:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40865
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754941AbZE0UzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:55:00 -0400
Date: Wed, 27 May 2009 13:55:00 -0700 (PDT)
Message-Id: <20090527.135500.217447785.davem@davemloft.net>
To: timur@freescale.com
Cc: scottwood@freescale.com, rmk+lkml@arm.linux.org.uk, jacmet@sunsite.dk,
       r.schwebel@pengutronix.de, devicetree-discuss@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       yuan-bo.ye@motorola.com
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A1DA24D.5000101@freescale.com>
References: <4A1D9A66.5020002@freescale.com>
	<20090527.132553.40558501.davem@davemloft.net>
	<4A1DA24D.5000101@freescale.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Timur Tabi <timur@freescale.com>
Date: Wed, 27 May 2009 15:27:57 -0500

> I asked what do drivers do when the MAC address is not in the OF
> tree, and it is not programmed in hardware (any hardware).

They either fail to probe the device or use a random MAC address,
the later of which is severely frowned upon.
