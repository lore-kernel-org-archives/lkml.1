Return-Path: <linux-kernel-owner+w=401wt.eu-S932299AbZJLOhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbZJLOhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbZJLOhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:37:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:51101 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756828AbZJLOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:37:29 -0400
Subject: Re: [PATCH] panic.c: export panic_on_oops
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091012142634.GB4565@elte.hu>
References: <20091012111545.GB8857@elte.hu>
	 <1255346731.9659.31.camel@localhost> <20091012113758.GB11035@elte.hu>
	 <20091012140149.6789efab@marrow.netinsight.se>
	 <20091012120951.GA16799@elte.hu>
	 <20091012142714.56362465@marrow.netinsight.se>
	 <20091012123210.GB22766@elte.hu>
	 <20091012140821.5dfa1598@lxorguk.ukuu.org.uk>
	 <20091012132503.GD25464@elte.hu>
	 <1255354342.30919.17.camel@macbook.infradead.org>
	 <20091012142634.GB4565@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Oct 2009 15:36:21 +0100
Message-Id: <1255358181.9111.14.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 16:26 +0200, Ingo Molnar wrote:
> Not if the failure is say a s2ram hang that requires a power cycle. Also 
> there are certain classes of bugs that only occur on cold boot. Plus 
> there's the "need to unplug the battery to revive the system" class of 
> bugs (but they are rare).

So you need to build in enough ECC to cope with the decay which happens
when RAM isn't being refreshed for a few seconds... :)

> So i think the MTD / flash stuff is powerful. 

Yeah, definitely. I was just pointing out that we can actually do a lot
better on today's commodity hardware too.

-- 
dwmw2

