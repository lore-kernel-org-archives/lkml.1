Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbZBNJvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbZBNJvh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 04:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZBNJvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 04:51:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60499
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751251AbZBNJvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 04:51:16 -0500
Date: Sat, 14 Feb 2009 01:51:10 -0800 (PST)
Message-Id: <20090214.015110.89500979.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5]: drm: ati_pcigart: Do not access I/O MEM space
 using pointer derefs.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090214.011145.102067430.davem@davemloft.net>
References: <20090213.220934.236067646.davem@davemloft.net>
	<1234602474.26036.83.camel@pasglop>
	<20090214.011145.102067430.davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sat, 14 Feb 2009 01:11:45 -0800 (PST)

> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Sat, 14 Feb 2009 20:07:54 +1100
> 
> > We can do that by registering a surface from the kernel to cover the
> > GART I suppose, and clean things a bit so that when using the DRI, X
> > doesn't touch the surface registers -at all- and leaves it to the
> > kernel.
> 
> That actually sounds like a good idea.

Ok I have it working, patch coming right up.
