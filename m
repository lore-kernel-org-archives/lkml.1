Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbXGWPsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbXGWPsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 11:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbXGWPsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 11:48:05 -0400
Received: from mailhub.hp.com ([192.151.27.10]:50201 "EHLO mailhub.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbXGWPsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 11:48:04 -0400
From: "Bob Picco" <bob.picco@hp.com>
Date: Mon, 23 Jul 2007 11:47:54 -0400
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bob Picco <bob.picco@hp.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: Linus 2.6.23-rc1
Message-ID: <20070723154754.GG10653@localhost>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <46A40BC7.9030209@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A40BC7.9030209@googlemail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:	[Sun Jul 22 2007, 10:00:39PM EDT]
> Linus Torvalds wrote:
> > Ok, right on time, two weeks afetr 2.6.22, there's a 2.6.23-rc1 out there.
> 
> 
> ...
> 
> drivers/char/hpet.c:76: warning: integer constant is too large for 'long' type
> 
> ...
> 
> Introduced by 0aa366f351d044703e25c8425e508170e80d83b1 
> 
> 
> 
> 

Sorry about that. I thought my review had caught all of these.

Signed-off-by: Bob Picco <bob.picco@hp.com>

 drivers/char/hpet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-rc1/drivers/char/hpet.c
===================================================================
--- linux-2.6.23-rc1.orig/drivers/char/hpet.c	2007-07-23 10:08:58.000000000 -0400
+++ linux-2.6.23-rc1/drivers/char/hpet.c	2007-07-23 11:46:12.000000000 -0400
@@ -73,7 +73,7 @@ static struct clocksource clocksource_hp
         .name           = "hpet",
         .rating         = 250,
         .read           = read_hpet,
-        .mask           = 0xffffffffffffffff,
+        .mask           = 0xffffffffffffffffULL,
         .mult           = 0, /*to be caluclated*/
         .shift          = 10,
         .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
