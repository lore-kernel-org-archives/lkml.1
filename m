Return-Path: <linux-kernel-owner+w=401wt.eu-S1761365AbXFQXQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761365AbXFQXQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 19:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757752AbXFQXQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 19:16:10 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51846 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbXFQXQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 19:16:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4675C083.6080409@s5r6.in-berlin.de>
Date: Mon, 18 Jun 2007 01:15:15 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How to improve the quality of the kernel?
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <200706172053.41806.bzolnier@gmail.com> <20070617115258.1f55b29d.akpm@linux-foundation.org> <200706172349.08813.bzolnier@gmail.com>
In-Reply-To: <200706172349.08813.bzolnier@gmail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> despite the fact that audit takes
> more time/knowledge then making the patch you will end up with zero credit
> if patch turns out to be (luckily) correct.  Even if you find out issues
> and report them you are still on mercy of author for being credited

If we introduce a "Reviewed-by" with reasonably clear semantics
(different from Signed-off-by; e.g. the reviewer is not a middle-man in
patch forwarding; the reviewer might have had remaining reservations...
very similar to but not entirely the same as "Acked-by" as currently
defined in -mm) --- and also make the already somewhat established
"Tested-by" more official, --- then the maintainers could start to make
it a habit to add Reviewed-by and Tested-by.

Plus, reviewers and testers could formally reply with Reviewed-by and
Tested-by lines to patch postings and even could explicitly ask the
maintainer to add these lines.

> so from personal POV you are much better to wait and fix issues after they
> hit mainline kernel.  You have to choose between being a good citizen and
> preventing kernel regressions or being bastard and getting the credit. ;)
> 
> If you happen to be maintainer of the affected code the choice is similar
> with more pros for letting the patch in especially if you can't afford the
> time to do audit (and by being maintainer you are guaranteed to be heavily
> time constrained).

I don't think that a maintainer (who signs off on patches after all) can
easily afford to take the "bastard approach".  I may be naive.
-- 
Stefan Richter
-=====-=-=== -==- =--=-
http://arcgraph.de/sr/
