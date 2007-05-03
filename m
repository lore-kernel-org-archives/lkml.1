Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbXECP2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbXECP2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbXECP2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:28:05 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:45553 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272AbXECP2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:28:01 -0400
Date: Thu, 3 May 2007 17:22:25 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
cc: Arne Georg Gleditsch <argggh@dolphinics.no>,
       Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       trivial@kernel.org, davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: convert crypto.h to UTF-8
In-Reply-To: <alpine.DEB.0.98.0705030915240.21257@sigma.j-a-k-j.com>
Message-ID: <Pine.LNX.4.61.0705031719080.18504@yvahk01.tjqt.qr>
References: <alpine.DEB.0.83.0704171322280.914@sigma.j-a-k-j.com>
 <20070502044345.GA29384@gondor.apana.org.au> <alpine.DEB.0.98.0705030711020.17390@sigma.j-a-k-j.com>
 <87r6pyqg2b.fsf@pelargir.dolphinics.no> <alpine.DEB.0.98.0705030915240.21257@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 3 2007 09:21, John Anthony Kazos Jr. wrote:
>
>There's no reason for any non-UTF-8 to be in the tree at all, so 
>eventually it won't be a problem. I'm (slowly but surely) working on 
>converting everything in the tree. GCC handles UTF-8 just fine, and all 

In fact, GCC gives a crap about comments :)
and otherwise sees things as octets, not characters.
I think GCJ is the only one that really pays attention to encoding.

>non-stupid/non-broken distributions of GNU/Linux and other major Un*ces 
>should be based on (or at least compatible with) UTF-8 in basic 
>operations. Files like the keymaps will be more work to convert, but they 
>can be as well.
>
>I'm operating on the assumption that anything in the tree that isn't UTF-8 
>is ISO-8859-1. Of course, I'm also checking it by hand to make sure a 
>small-O-with-umlaut doesn't become the Klingon logo...

This is probably all you'll ever see:
http://lkml.org/lkml/2007/1/8/222


Jan
-- 
