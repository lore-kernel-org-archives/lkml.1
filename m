Return-Path: <linux-kernel-owner+w=401wt.eu-S933165AbXHAOFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165AbXHAOFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932307AbXHAOFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:05:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35349 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187AbXHAOFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:05:09 -0400
Subject: Re: CFS review
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070801135949.GA10839@elte.hu>
References: <20070711211638.GE18767@one.firstfloor.org>
	 <20070711214649.GK14435@v2.random>
	 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0707130415520.1818@scrub.home>
	 <1184302024.6709.11.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0707131728070.1817@scrub.home>
	 <1184389456.6632.13.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0708010439050.1817@scrub.home>
	 <20070801112229.GA11710@elte.hu>
	 <Pine.LNX.4.64.0708011346510.1817@scrub.home>
	 <20070801135949.GA10839@elte.hu>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 01 Aug 2007 07:04:34 -0700
Message-Id: <1185977074.2754.23.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> but that's nothing new. CFS cannot conjure up time measurement methods 
> that do not exist. If you have a low-res clock and if you create an app 
> that syncs precisely to the tick of that clock via timers that run off 
> that exact tick then there's nothing the scheduler can do about it. It 
> is false to charachterise this as 'sleeper starvation' or 'rounding 
> error' like you did. No amount of rounding logic can create a 
> high-resolution clock out of thin air.


CFS is only as fair as your clock is good.


