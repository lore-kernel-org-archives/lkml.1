Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbYEZS4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbYEZS4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 14:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbYEZS4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 14:56:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59869 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbYEZS43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 14:56:29 -0400
Date: Mon, 26 May 2008 20:57:13 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>
Subject: iommu mess: is there a better way?
Message-ID: <20080526185713.GA17523@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

aperture_64.c is basically a subset of drivers/char/agp/amd64-agp.c
... with the exception that it uses hand-coded pci access so that it
can run early... because it needs to allocate 64MB of ram.

Could we simply always allocate 64MB of ram for agp, and then free
them from amd64-agp.c if they are not needed?

I'm not quite sure how pci-gart_64.c fits into the picture. It seems
to duplicate the other half of amd64-agp.c...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
