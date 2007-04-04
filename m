Return-Path: <linux-kernel-owner+w=401wt.eu-S966234AbXDDBRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966234AbXDDBRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966233AbXDDBRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:17:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47095
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S966235AbXDDBRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:17:35 -0400
Date: Tue, 03 Apr 2007 18:17:33 -0700 (PDT)
Message-Id: <20070403.181733.27782389.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: dwmw2@infradead.org, flar@allandria.com, paulus@samba.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1175649192.30879.19.camel@localhost.localdomain>
References: <20070403.170212.02298297.davem@davemloft.net>
	<1175645568.10567.42.camel@shinybook.infradead.org>
	<1175649192.30879.19.camel@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 04 Apr 2007 11:13:12 +1000

> It worked before the new serial core, we had a "tweak" in the old 8250
> driver to be able to share minors, but that got busted when Russell
> rewrote the whole thing. I remember asking him back when he still was
> the serial maintainer, and he refused to bring back some sharing of
> minors.

Fork the 8250 driver like I did on Sparc so you can get the
dynamic minor behavior back :-))))
