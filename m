Return-Path: <linux-kernel-owner+w=401wt.eu-S1752134AbZBNJJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbZBNJJy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 04:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbZBNJJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 04:09:40 -0500
Received: from gate.crashing.org ([63.228.1.57]:40437 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbZBNJJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 04:09:40 -0500
Subject: Re: [PATCH 1/5]: drm: ati_pcigart: Do not access I/O MEM space
 using  pointer derefs.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dave Airlie <airlied@gmail.com>
Cc: David Miller <davem@davemloft.net>, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <21d7e9970902132342k1a756475t91ede4baf571c563@mail.gmail.com>
References: <20090212.021527.12463602.davem@davemloft.net>
	 <1234434959.29851.55.camel@pasglop>
	 <20090213.220934.236067646.davem@davemloft.net>
	 <21d7e9970902132342k1a756475t91ede4baf571c563@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 14 Feb 2009 20:09:24 +1100
Message-Id: <1234602564.26036.84.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The only think I can think to do is use a surface instead of the
> aperture swappers
> and make the surface cover all the VRAM except the GART table which is
> at the end.

Why not use a surface to cover the GART ? At least this would ensure a
known swapper setting for it. 

> That's interesting, it could explain why things never work again after a reset
> or at least proceed to hang straight away.

No shit :-)

Cheers,
Ben.


