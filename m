Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbYKPUho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbYKPUho (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 15:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYKPUhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 15:37:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54146
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbYKPUhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 15:37:33 -0500
Date: Sun, 16 Nov 2008 12:37:32 -0800 (PST)
Message-Id: <20081116.123732.74733883.davem@davemloft.net>
To: miltonm@bga.com
Cc: jdb@comx.dk, segher@kernel.crashing.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] niu: bitwise or does not imply ordering
From: David Miller <davem@davemloft.net>
In-Reply-To: <312268717986b8b45674.846930886.miltonm@bga.com>
References: <312268717986b8b45674.846930886.miltonm@bga.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milton Miller <miltonm@bga.com>
Date: Sun, 16 Nov 2008 15:43:18 -0600

> commit e23a59e1ca6d177a57a7791b3629db93ff1d9813 (niu: Fix readq
> implementation when architecture does not provide one.) reordered the
> arguments to a bitwise or to change the emitted code.   However, C does
> not guarantee the evaluation order.

I'm not applying this patch, the problem is in your
imagination only.
