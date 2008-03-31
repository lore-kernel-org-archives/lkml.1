Return-Path: <linux-kernel-owner+w=401wt.eu-S1752507AbYCaODJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbYCaODJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbYCaOC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:02:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2158 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750788AbYCaOC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:02:57 -0400
Date: Mon, 31 Mar 2008 16:02:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: MCE going wild, 14 megs of this in the logs
Message-ID: <20080331140243.GA6212@ucw.cz>
References: <200803301657.53232.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803301657.53232.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-03-30 16:57:53, Gene Heskett wrote:
> Greetings;
> Mar 30 16:46:42 coyote kernel: [469249.031832] MCE: The hardware reports a non 
> fatal, correctable incident occurred on CPU 0.
> Mar 30 16:46:42 coyote kernel: [469249.031838] Bank 1: d400400000000152
> Mar 30 16:46:42 coyote kernel: [469249.031841] MCE: The hardware reports a non 
> fatal, correctable incident occurred on CPU 0.
> Mar 30 16:46:42 coyote kernel: [469249.031844] Bank 2: d40040000000017a
> 
> Its always the same 2 addresses reported, and every 15 seconds.  So I have the 
> non-fatal part of MCE now turned off, & 2.6.24.4 rebuilding.
> 
> I saw this once before, and a nearly round the clock run of memtest86 gave my 
> memory a clean bill.  Processor is an XP-2800, biostar mainboard with NForce2 
> chipset.  Is this possibly a known artifact of this hardware?

Thats expected. If ECC can correct the problem, memtest will pass.

I had similar problems, and was told by AMD that I had cpu with bad L2 cache.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
