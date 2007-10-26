Return-Path: <linux-kernel-owner+w=401wt.eu-S1759131AbXJZLXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759131AbXJZLXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 07:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbXJZLXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 07:23:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42663
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751085AbXJZLXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 07:23:40 -0400
Date: Fri, 26 Oct 2007 04:23:41 -0700 (PDT)
Message-Id: <20071026.042341.177691569.davem@davemloft.net>
To: jeff@garzik.org
Cc: benh@kernel.crashing.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] napi: use non-interruptible sleep in napi_disable
From: David Miller <davem@davemloft.net>
In-Reply-To: <47202548.6040100@garzik.org>
References: <20071025035920.C2D39DDECE@ozlabs.org>
	<47202548.6040100@garzik.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Thu, 25 Oct 2007 01:10:32 -0400

> Benjamin Herrenschmidt wrote:
> > The current napi_disable() uses msleep_interruptible() but doesn't
> > (and can't) exit in case there's a signal, thus ending up doing a
> > hot spin without a cpu_relax. Use uninterruptible sleep instead.
> > 
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
 ...
> ACK

Applied, thanks everyone.
