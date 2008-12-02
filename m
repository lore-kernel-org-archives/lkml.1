Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbYLBOss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbYLBOss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 09:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbYLBOsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 09:48:37 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33505 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754911AbYLBOsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 09:48:36 -0500
Date: Tue, 2 Dec 2008 15:48:30 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: tytso@mit.edu
Subject: SD/MMC cards: how crappy they are?
Message-ID: <20081202144830.GB1549@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have 32GB card here...

root@amd:/home/pavel/WWW/wear/tinylight# time cat /dev/mmc1 > /dev/null
cat: /dev/mmc1: Input/output error
1.32user 49.03system 4184.78 (69m44.789s) elapsed 1.20%CPU

...maybe it was because of powerfail? I'll try to run badblocks to
recover it...

...I did. Badblocks did not help, but cat /dev/zero > /dev/mmc1
did.. And yes, thosse 'temporarily bad blocks' seem very much
powerfail related.

Its bad, because ext2/3 does not seem to handle this very well... not
even fsck does the selective rewrite... :-(.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
