Return-Path: <linux-kernel-owner+w=401wt.eu-S1161286AbXCGEU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161286AbXCGEU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 23:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161279AbXCGEUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 23:20:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42743
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1161282AbXCGEUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 23:20:55 -0500
Date: Tue, 06 Mar 2007 20:20:52 -0800 (PST)
Message-Id: <20070306.202052.03980320.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: rkuhn@e18.physik.tu-muenchen.de, andi@firstfloor.org, dada1@cosmosbay.com,
       jengelh@linux01.gwdg.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] tcp_cubic: faster cube root
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070306144706.4585c079@freekitty>
References: <20070306102941.32471d57@freekitty>
	<20070306.135834.26100913.davem@davemloft.net>
	<20070306144706.4585c079@freekitty>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Tue, 6 Mar 2007 14:47:06 -0800

> The Newton-Raphson method is quadratically convergent so
> only a small fixed number of steps are necessary.
> Therefore it is faster to unroll the loop. Since div64_64 is no longer
> inline it won't cause code explosion.
> 
> Also fixes a bug that can occur if x^2 was bigger than 32 bits.
> 
> Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

Applied, thanks Stephen.
