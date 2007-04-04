Return-Path: <linux-kernel-owner+w=401wt.eu-S2992744AbXDDInk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992744AbXDDInk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 04:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992752AbXDDInk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 04:43:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38837
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2992744AbXDDInj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 04:43:39 -0400
Date: Wed, 04 Apr 2007 01:43:30 -0700 (PDT)
Message-Id: <20070404.014330.91315500.davem@davemloft.net>
To: rmk+lkml@arm.linux.org.uk
Cc: dwmw2@infradead.org, paulus@samba.org, alan@lxorguk.ukuu.org.uk,
       flar@allandria.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070404083803.GA13134@flint.arm.linux.org.uk>
References: <1175666635.2932.17.camel@shinybook.infradead.org>
	<20070404.011208.120446173.davem@davemloft.net>
	<20070404083803.GA13134@flint.arm.linux.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+lkml@arm.linux.org.uk>
Date: Wed, 4 Apr 2007 09:38:03 +0100

> However, despite people pressing for it, there's yet to be a *sane*
> *technical* *solution* to the problem.  All I've seen so far is one
> bad hack.

Well the "bad hack" we use on sparc gives usable serial ports,
properly ordered and using /dev/ttyS0, with a proper matching
console selection.
