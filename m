Return-Path: <linux-kernel-owner+w=401wt.eu-S1759606AbYJMKOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbYJMKOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765533AbYJMKCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:02:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47828
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1763436AbYJMKCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:02:14 -0400
Date: Mon, 13 Oct 2008 03:01:50 -0700 (PDT)
Message-Id: <20081013.030150.96524866.davem@davemloft.net>
To: cooloney@kernel.org
Cc: ben@simtec.co.uk, s.hauer@pengutronix.de, jeff@garzik.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jherrero@hvsistemas.es
Subject: Re: [PATCH 1/1] netdev: DM9000: Added typecasting to supress some
 warnings on Blackfin
From: David Miller <davem@davemloft.net>
In-Reply-To: <1223889009-31336-1-git-send-email-cooloney@kernel.org>
References: <1223889009-31336-1-git-send-email-cooloney@kernel.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bryan Wu <cooloney@kernel.org>
Date: Mon, 13 Oct 2008 17:10:09 +0800

> From: Javier Herrero <jherrero@hvsistemas.es>
> 
> Signed-off-by: Javier Herrero <jherrero@hvsistemas.es>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

This is not only inelegant, it'll likely break things on
64-bit MIPS or any other case where the upper 32-bit matter.

I'd rather see Blackfin fix it's I/O accessor prototypes
to take a proper __iomem pointer.

This patch won't be applied.
