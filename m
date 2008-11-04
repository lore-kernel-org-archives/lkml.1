Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbYKDLCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbYKDLCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 06:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYKDLC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 06:02:27 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54754 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbYKDLC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 06:02:26 -0500
Date: Tue, 4 Nov 2008 12:02:25 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: ext2/3 vs. kingston 32G SD card
Message-ID: <20081104110225.GB4514@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I got 32GB kingston SD card, and am using it with ext2 for storing git
trees etc.

Unfortunately, every time I run fsck, I get rather nasty corruption. 
I switched it to ext3 now, but I believe I have seen corruption even
on volume marked clean, which should be impossible from user error.

If I suspect wrong block device, what are useful tests to run there?

Or maybe I should do some test on filesystem level? (So far I try
compiling kernels, but that does not seem to provoke the corruption.)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
