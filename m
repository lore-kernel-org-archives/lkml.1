Return-Path: <linux-kernel-owner+w=401wt.eu-S933768AbXKOV5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933768AbXKOV5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765694AbXKOV5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:57:36 -0500
Received: from zakalwe.fi ([80.83.5.154]:54308 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932794AbXKOV5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:57:35 -0500
Date: Thu, 15 Nov 2007 23:57:33 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 08/16] skge: fix ram buffer size calculation
Message-ID: <20071115215733.GL8865@zakalwe.fi>
References: <20071115060353.071060513@mini.kroah.org> <20071115064037.GH18951@kroah.com> <alpine.LFD.0.9999.0711150810130.2786@woody.linux-foundation.org> <473C736D.2040307@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <473C736D.2040307@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 08:27:25AM -0800, Stephen Hemminger wrote:
> I can't reproduce the users problem with the hardware I have. And 
> without the patch the dual
> port board doesn't work. So it is a question of regression, versus 
> fixing pre-existing bugs.
> I am okay with reverting the patch, as a temporary state, but concerned 
> with how
> to make progress in fixing this.

I can reproduce the bug in a second. I will test any version you send 
me. I take it you have tested the driver on gigabit ethernet by sending 
zero from one netcat to another (the sending machine being something, 
and the receiving machine being skge)?

The only thing that needed to be done for the last 6 patches in the
mainline was reversing the order of two register writes, meaning that 
the dual port stuff need not be thrown away. This was explained in my 
bug report (that was hard to read). I'm not suggesting this is a proper 
fix. In fact, I think it's not, because we can not explain the problem.

It would _very_ nice to get to the bottom of this issue, so I would 
favor reverting the patch and trying and debugging carefully before 
creating quick and dirty fixes..

Thank you all..

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
