Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbZG0Sjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbZG0Sjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbZG0Sjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:39:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44749
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754107AbZG0Sju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:39:50 -0400
Date: Mon, 27 Jul 2009 11:39:57 -0700 (PDT)
Message-Id: <20090727.113957.63290485.davem@davemloft.net>
To: julia@diku.dk
Cc: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/12] drivers/atm: Correct redundant test
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0907271812130.2682@ask.diku.dk>
References: <Pine.LNX.4.64.0907271812130.2682@ask.diku.dk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Mon, 27 Jul 2009 18:12:34 +0200 (CEST)

> From: Julia Lawall <julia@diku.dk>
> 
> str has already been tested.  It seems that this test should be on the
> recently returned value snr.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://www.emn.fr/x-info/coccinelle/)
...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, but as per the MAINTAINERS entry, please CC: ATM patches
to netdev@vger.kernel.org, thanks:

ATM
P:	Chas Williams
M:	chas@cmf.nrl.navy.mil
L:	linux-atm-general@lists.sourceforge.net (subscribers-only)
L:	netdev@vger.kernel.org
W:	http://linux-atm.sourceforge.net
S:	Maintained
F:	drivers/atm/
F:	include/linux/atm*
