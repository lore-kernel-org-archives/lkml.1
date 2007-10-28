Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbXJ1SMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbXJ1SMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 14:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbXJ1SL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 14:11:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4531 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752650AbXJ1SL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 14:11:56 -0400
Date: Sun, 28 Oct 2007 18:07:07 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
Message-ID: <20071028180707.GA6111@ucw.cz>
References: <20071014190128.6e3cdb44@bree.surriel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071014190128.6e3cdb44@bree.surriel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> - Are large enough to qualify as a student project, luckily there is
>   flexibility here since we get inquiries for anything from 6 week
>   projects to 6 month projects.
> 
> If you have ideas on what projects would be useful, please add them
> to this page (or email me):

Hard stuff:

* network character device -- similar to nbd, but for char devices.
  either figure out how to forward ioctls(), or implement
  usb-over-network, or...

* openMosix -- they seem to have userspace solution, but not GPLed.

* compression for ext4. Its about time someone did it right. Special
  bonus if you can do it in a way that it does not slow down. If cpu
  is free, compress, if it is busy, just write it straight to disk.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
