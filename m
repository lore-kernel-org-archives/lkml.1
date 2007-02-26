Return-Path: <linux-kernel-owner+w=401wt.eu-S1161290AbXBZWTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161290AbXBZWTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 17:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161293AbXBZWTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 17:19:50 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47621 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161290AbXBZWTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 17:19:48 -0500
Date: Mon, 26 Feb 2007 23:00:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       george@mvista.com
Subject: 2.6.21-rc1: beeps get longer after suspend
Message-ID: <20070226220001.GA2200@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Yes, it is strange, and it is also regression from 2.6.20.

pavel@amd:/data/l/linux$ cat .config | grep HZ
# CONFIG_NO_HZ is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
pavel@amd:/data/l/linux$ cat .config | grep HIRES
pavel@amd:/data/l/linux$ cat .config | grep HIGH
# CONFIG_HIGH_RES_TIMERS is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_HIGHMEM=y
# CONFIG_HIGHPTE is not set
CONFIG_DEBUG_HIGHMEM=y
pavel@amd:/data/l/linux$

pavel@amd:~$ date; sleep 1; date
Mon Feb 26 22:56:23 CET 2007
Mon Feb 26 22:56:24 CET 2007
pavel@amd:~$

....seems to work well...

Also, we need timer subsystem entry into MAINTAINERS file :-)

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
