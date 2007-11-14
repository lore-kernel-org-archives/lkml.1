Return-Path: <linux-kernel-owner+w=401wt.eu-S1761212AbXKNWWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761212AbXKNWWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 17:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbXKNWWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 17:22:24 -0500
Received: from zakalwe.fi ([80.83.5.154]:60561 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbXKNWWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 17:22:24 -0500
Date: Thu, 15 Nov 2007 00:22:22 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Kujau <lists@nerdbynature.de>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071114222222.GJ8865@zakalwe.fi>
References: <20071113034916.2556edd7.akpm@linux-foundation.org> <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de> <20071113130411.26ccae12.akpm@linux-foundation.org> <200711140356.31483.nickpiggin@yahoo.com.au> <alpine.LFD.0.9999.0711141144080.2786@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0711141144080.2786@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 11:54:16AM -0800, Linus Torvalds wrote:
> Actually, I'm pretty happy reverting patches that cause regressions even 
> if it *can* be "fixed for release". If there isn't a fix available within 
> a day or two, it should get reverted.
> ...
> Also, please notice the latter part of the suggestion above: even if 
> somebody has bisected down their problem to a specific commit, I really 
> *do* want to hear that actually undoing the commit on top of the current 
> tree acually fixes it again, because sometimes that just isn't the case - 
> sometimes you end up having various interactions that means that reverting 
> a commit might simply not even work.

Ok. drivers/net/skge has been broken for several weeks. I have manually 
fixed the driver at each rc* release since then.

Please revert skge changes, the commit that broke driver is
7fb7ac241162dc51ec0f7644d4a97b2855213c32

See
	http://bugzilla.kernel.org/show_bug.cgi?id=9321

for more information. I think Stephen Hemminger is working on the skge 
fix, but it has been several days since I've heard anything from him.

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
