Return-Path: <linux-kernel-owner+w=401wt.eu-S933889AbXIKTBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933889AbXIKTBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933762AbXIKTAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:00:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:34145 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933753AbXIKS76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:59:58 -0400
Date: Tue, 11 Sep 2007 21:00:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, ben.collins@ubuntu.com,
       stefanr@s5r6.in-berlin.de, linux1394-devel@lists.sourceforge.net
Subject: regression: fireware causes oops during system
Message-ID: <20070911190043.GA1577@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I noticed empty suspend stopped working around 2.6.23-rc4, and it is
still present in 2.6.23-rc6. To reproduce

swapoff -a 
echo disk > /sys/power/state
echo disk > /sys/power/state

Unsetting

CONFIG_IEEE1394=y

solves the problem.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
