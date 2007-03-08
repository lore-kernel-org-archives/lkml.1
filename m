Return-Path: <linux-kernel-owner+w=401wt.eu-S1750913AbXCHCzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750913AbXCHCzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 21:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbXCHCzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 21:55:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54762
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750913AbXCHCzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 21:55:41 -0500
Date: Wed, 07 Mar 2007 18:55:39 -0800 (PST)
Message-Id: <20070307.185539.48527371.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: w@1wt.eu, rkuhn@e18.physik.tu-muenchen.de, andi@firstfloor.org,
       dada1@cosmosbay.com, jengelh@linux01.gwdg.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] tcp_cubic: use 32 bit math
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070307170731.2b4397e3@freekitty>
References: <20070306145842.7d7fea84@freekitty>
	<20070307060838.GI943@1wt.eu>
	<20070307170731.2b4397e3@freekitty>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Wed, 7 Mar 2007 17:07:31 -0800

> The basic calculation has to be done in 32 bits to avoid
> doing 64 bit divide by 3. The value x is only 22bits max
> so only need full 64 bits only for x^2.
> 
> Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

Applied, thanks Stephen.

What about Willy Tarreau's supposedly even faster variant?
Or does this incorporate that set of improvements?
