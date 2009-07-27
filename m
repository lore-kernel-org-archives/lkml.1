Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbZG0VXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbZG0VXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZG0VXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:23:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484AbZG0VXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:23:23 -0400
Date: Mon, 27 Jul 2009 14:22:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
In-Reply-To: <20090727215250.034f7d4b@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.01.0907271421080.25224@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <87bpn7mzli.fsf@devron.myhome.or.jp> <20090727115723.1e8de60e@lxorguk.ukuu.org.uk> <873a8iqqgv.fsf@devron.myhome.or.jp> <20090727142303.41096bf5@lxorguk.ukuu.org.uk> <877hxujkuv.fsf@devron.myhome.or.jp>
 <20090727145805.690afe5d@lxorguk.ukuu.org.uk> <87fxci6ub9.fsf@devron.myhome.or.jp> <20090727161424.GA4233@skywalker> <20090727174252.2d987830@lxorguk.ukuu.org.uk> <20090727171213.GB4233@skywalker> <87skgikjr8.fsf@devron.myhome.or.jp>
 <alpine.LFD.2.01.0907271237250.25224@localhost.localdomain> <20090727215250.034f7d4b@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 27 Jul 2009, Alan Cox wrote:
>
> Nor can we revert several patches because the ppp stuff means going back
> to about 2.6.28 or so for the entire tty layer plus some of the DoS and
> null pointer races go back to 2.2 or 2.0 8(.

The thing is, breaking ppp and reverting at least to 2.6.30 behavior. 
Since it's better than the _current_ breakage.

> We can use the two line slightly imperfect quickfix which people reported
> does fix their problem and I'm tempted to go with that for 2.6.31 because
> it works for the real world cases that matter.

Umm. Which ones? People have reported kdesu and emacs breaking. Last I 
saw, the emacs breakage wasn't fixed by any of the patches seen so far.

		Linus
