Return-Path: <linux-kernel-owner+w=401wt.eu-S1759165AbXERB1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165AbXERB1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 21:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbXERB1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 21:27:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:33364 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536AbXERB1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 21:27:02 -0400
Subject: Re: radeonfb and X800 cards
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: Luca Tettamanti <kronos.it@gmail.com>, Daniel Drake <dsd@gentoo.org>,
       linux list <linux-kernel@vger.kernel.org>, Jimmy.Jazz@gmx.net
In-Reply-To: <b637ec0b0705171329i6da89fa8h655976e823aef41e@mail.gmail.com>
References: <464BB43D.2020407@gentoo.org>
	 <1179367164.32247.256.camel@localhost.localdomain>
	 <20070517195958.GA6489@dreamland.darkstar.lan>
	 <b637ec0b0705171329i6da89fa8h655976e823aef41e@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 18 May 2007 11:26:52 +1000
Message-Id: <1179451612.32247.329.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 22:29 +0200, Fabio Comolli wrote:

> Is there a reason why this patch can't go upstream?

Yes. A change of that magnitude will most certainly introduce
regressions. So we can either:

 - Have it in -mm for monthes trying to iron out all of them (and we'll
miss some). And struggle also since it's hard to track subtle
regressions with very big patches.

 - Have it split in smaller bits, which make it possible to bisect in
case of problem, and thus find/correct problems much faster.

That's my main issue with it at this point. But I'm ok going for route
#1 provided that you guys are willing to help with tracking regressions
down. That also mean I need to do some serious testing on powermacs
since those rely very heavily on a working radeonfb.

Ben.


