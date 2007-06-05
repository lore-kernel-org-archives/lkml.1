Return-Path: <linux-kernel-owner+w=401wt.eu-S1762752AbXFERBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762752AbXFERBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 13:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbXFERBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 13:01:44 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754752AbXFERBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 13:01:44 -0400
Date: Tue, 5 Jun 2007 09:58:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: dean gaudet <dean@arctic.org>
cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Andi Kleen <ak@suse.de>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, guilherme@centralinf.com.br,
       johnstul@us.ibm.com
Subject: Re: [patch 43/69] i386: HPET, check if the counter works
In-Reply-To: <Pine.LNX.4.64.0706050951240.20704@twinlark.arctic.org>
Message-ID: <alpine.LFD.0.98.0706050957480.23741@woody.linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org> <20070521191740.534306000@sous-sol.org>
 <Pine.LNX.4.64.0706050951240.20704@twinlark.arctic.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 Jun 2007, dean gaudet wrote:
>
> the HPET specification allows for HPETs with *much* lower resolution than 
> 50us.  in fact Fmin is 10Hz iirc.  (sorry to jump in so late, but i'm 
> about a month behind on the list.)

Well, for such a broken HPET, the right thing to do is to just not use it, 
so who cares? It might as well be considered non-incrementing at all.

		Linus
