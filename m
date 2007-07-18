Return-Path: <linux-kernel-owner+w=401wt.eu-S1762758AbXGRJWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762758AbXGRJWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 05:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbXGRJW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:22:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55052
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751521AbXGRJWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:22:25 -0400
Date: Wed, 18 Jul 2007 02:22:24 -0700 (PDT)
Message-Id: <20070718.022224.69408970.davem@davemloft.net>
To: bunk@stusta.de
Cc: netdev@vger.kernel.org, cilly@cilly.mine.nu,
       netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
       kaber@coreworks.de
Subject: Re: [2.6 patch] ipt_iprange.h must #include <linux/types.h>
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070715121419.GK3565@stusta.de>
References: <20070715121419.GK3565@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Sun, 15 Jul 2007 14:14:19 +0200

> ipt_iprange.h must #include <linux/types.h> since it uses __be32.
> 
> This patch fixes kernel Bugzilla #7604.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Applied, and I'll push this to -stable too, thanks Adrian.
