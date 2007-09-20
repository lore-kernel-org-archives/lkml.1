Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbXITKcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbXITKcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 06:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbXITKcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 06:32:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58130 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbXITKcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 06:32:09 -0400
Date: Thu, 20 Sep 2007 12:32:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com,
       kernel list <linux-kernel@vger.kernel.org>,
       dbrownell@users.sourceforge.net
Subject: RTC wakealarm write-only, still has 644 permissions
Message-ID: <20070920103225.GA4410@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

...should they be changed to 200? Or perhaps file should be readable?

root@amd:/sys/class/rtc/rtc0# cat wakealarm 
root@amd:/sys/class/rtc/rtc0# echo 132719 > wakealarm 
root@amd:/sys/class/rtc/rtc0# ls -al wakealarm 
-rw-r--r-- 1 root root 0 Sep 20 12:30 wakealarm
root@amd:/sys/class/rtc/rtc0# cat wakealarm 
root@amd:/sys/class/rtc/rtc0# cat wakealarm 
root@amd:/sys/class/rtc/rtc0# 


...standard PC with reasonably recent kernel...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
