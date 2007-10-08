Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbXJHWHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbXJHWHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 18:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbXJHWHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 18:07:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:39624 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbXJHWHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 18:07:34 -0400
Date: Tue, 9 Oct 2007 00:07:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arjan van de Ven <arjan@infradead.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: gigabit ethernet power consumption
Message-ID: <20071008220720.GF3484@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I've found that gbit vs. 100mbit power consumption difference is about
1W -- pretty significant. (Maybe powertop should include it in the
tips section? :).

Energy Star people insist that machines should switch down to 100mbit
when network is idle, and I guess that makes a lot of sense -- you
save 1W locally and 1W on the router.

Question is, how to implement it correctly? Daemon that would watch
data rates and switch speeds using mii-tool would be simple, but is
that enough?
									Pavel 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
