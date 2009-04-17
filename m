Return-Path: <linux-kernel-owner+w=401wt.eu-S1758347AbZDQHzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347AbZDQHzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 03:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZDQHzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 03:55:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43931
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751400AbZDQHzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 03:55:00 -0400
Date: Fri, 17 Apr 2009 00:54:51 -0700 (PDT)
Message-Id: <20090417.005451.215477692.davem@davemloft.net>
To: bn@niasdigital.com
Cc: hskinnemoen@atmel.com, jgarzik@pobox.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] macb: Kconfig net device compat fixup
From: David Miller <davem@davemloft.net>
In-Reply-To: <1239953045.2837.58.camel@linux-51e8.site>
References: <1239953045.2837.58.camel@linux-51e8.site>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Nizette <bn@niasdigital.com>
Date: Fri, 17 Apr 2009 17:24:05 +1000

> The macb driver hasn't been updated to use net_device_ops and as such
> should select COMPAT_NET_DEV_OPS to avoid build breakage.
> 
> Of course really macb should be updated but in the mean time, this at
> least avoid randconfig problems.
> 
> Signed-off-by: Ben Nizette <bn@niasdigital.com>

There's about 26 drivers that fall into this category, it's senseless
to pepper the tree over with this kind of annotation that we'll just
release come next release.

We do have enough drivers converted that powerpc, sparc64, and x86
allmodconfig and allyesconfig builds pass even with the compat option
disabled.

And I think the others can just cope with this for now.

Actually, in the net-next-2.6 tree this driver has in fact been
converted :-)
