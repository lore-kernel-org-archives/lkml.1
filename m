Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbXCULjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbXCULjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 07:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbXCULjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 07:39:42 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34460 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752449AbXCULjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 07:39:41 -0400
Date: Wed, 21 Mar 2007 12:39:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: device@lanana.org, kernel list <linux-kernel@vger.kernel.org>
Cc: drzeus-mmc@drzeus.cx
Subject: major number allocation for mmc block devices
Message-ID: <20070321113936.GA5672@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'd like to get stable major number for mmc subsystem. Relying on
dynamic major for mmc is nasty, as it means that udev is neccessary on
the machine.

179 block       MMC block devices
                  0 = /dev/mmcblk0      First SD/MMC card
                  1 = /dev/mmcblk0p1    First partition on first MMC card
                  8 = /dev/mmcblk1      Second SD/MMC card
                    ...


Thanks,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
