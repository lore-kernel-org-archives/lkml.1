Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYLZVat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYLZVat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 16:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYLZVal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 16:30:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37620 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbYLZVak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 16:30:40 -0500
Date: Fri, 26 Dec 2008 22:30:39 +0100
From: Pavel Machek <pavel@suse.cz>
To: tytso@MIT.EDU, kernel list <linux-kernel@vger.kernel.org>
Subject: ext3 defaults to errors=continue, why?
Message-ID: <20081226213039.GA23836@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

in-tree documentation says that default for ext3 is errors=remount-ro,
and that's sensible, but I see errors=continue on my disks, due to
superblock settings. (Maybe documentation should mention that?)

I don't know where errors=continue came from (and I think its
dangerous); mkfs does not seem to have such option, nor can I see
anything in /etc/mke2fs.conf...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
