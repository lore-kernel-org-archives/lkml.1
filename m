Return-Path: <linux-kernel-owner+w=401wt.eu-S1757787AbYJIJCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbYJIJCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 05:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbYJIJBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 05:01:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44919 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbYJIJBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 05:01:52 -0400
Date: Thu, 9 Oct 2008 11:01:51 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: is memmap=200m@200m,exactmap supposed to work
Message-ID: <20081009090151.GD29957@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm trying to debug weirdly crashing machine.

Interesting part is "blue lightning" screen corruption that happens
just after you press "enter" in grub.

I'd like to tell the machine not to use low memory, and not to use
memory near graphics ram. Ideally, I'd like to

memmap=200m@200m,exactmap

...but that will not boot, with "BUG: Int 6: CR2 00000000". Is there
any "known good, but very safe, memory map I should pass?"

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
