Return-Path: <linux-kernel-owner+w=401wt.eu-S1759719AbXLLLac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759719AbXLLLac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbXLLLaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:30:22 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36189 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752110AbXLLLaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:30:21 -0500
Date: Wed, 12 Dec 2007 12:30:47 +0100
From: Pavel Machek <pavel@suse.cz>
To: jikos@suse.cz, kernel list <linux-kernel@vger.kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Subject: Celeron cpu vs. i810 chipset
Message-ID: <20071212113047.GC11859@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

We have strange problem with Celeron on i810 mainboards here: machine
reproducibly hangs in test 8 from memtest, and randomly hangs running
linux. (Problem is not bad RAM, not bad powersupply, and not related
to powersaving).

It seems that heavy memory traffic just makes it hang, as soon as main
memory (not L2 cache) is hit.

CPU runs at 8.5x bus clock, ISTR something was wrong with half
multipliers somewhere.

Unfortunately, Intel's web is less than helpful:

> Note: The 810 chipset may contain design defects or errors known as errata
> which may cause the product to deviate from published specifications. Current
> characterized errata are available on request.
> http://developer.intel.com/design/chipsets/810/

...so perhaps someone else can help?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
