Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbYEZSqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbYEZSqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 14:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbYEZSqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 14:46:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54228 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770AbYEZSqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 14:46:22 -0400
Date: Mon, 26 May 2008 20:47:03 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: pci-gart_64.c: could we get better explanation?
Message-ID: <20080526184703.GA17369@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

+++ b/arch/x86/kernel/pci-gart_64.c
@@ -774,6 +778,7 @@ #endif
 
        /*
         * Try to workaround a bug (thanks to BenH)
         * Set unmapped entries to a scratch page instead of 0.
         * Any prefetches that hit unmapped entries won't get an bus abort

Could someone explain? Which bug is being worked around? CPUs
prefetching over NULL?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
