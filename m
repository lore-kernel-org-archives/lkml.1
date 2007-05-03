Return-Path: <linux-kernel-owner+w=401wt.eu-S934045AbXEGNxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934045AbXEGNxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 09:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934017AbXEGNxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 09:53:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4735 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934021AbXEGNxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 09:53:23 -0400
Date: Thu, 3 May 2007 17:18:43 +0000
From: Pavel Machek <pavel@ucw.cz>
To: David Lang <david.lang@digitalinsight.com>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
Message-ID: <20070503171843.GA4355@ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704280041.17617.rjw@sisk.pl> <alpine.LFD.0.98.0704271612380.9964@woody.linux-foundation.org> <200704280145.26253.rjw@sisk.pl> <1177718250.4737.222.camel@nigel.suspend2.net> <Pine.LNX.4.63.0704271638150.11000@qynat.qvtvafvgr.pbz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0704271638150.11000@qynat.qvtvafvgr.pbz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> nobody is suggesting that you leave peocesses running 
> while you do the snapshot, what is being proposed is
> 
> 1. pause userspace (prevent scheduling)
> 2. make snapshot image of memory
> 3. make mounted filesystems read-only (possibly with 
> snapshot/checkpoint)
> 4. unpause
> 5. save image (with full userspace available, including 
> network)

Including network? Your tcp peers will be really confused, then, if
you ACK packets then claim you did not get them. No, you do not want
to start network.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
