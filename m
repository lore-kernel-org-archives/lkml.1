Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbXBSFOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbXBSFOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 00:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXBSFOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 00:14:35 -0500
Received: from washoe.rutgers.edu ([165.230.95.67]:37280 "EHLO
	smtp.onerussian.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbXBSFOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 00:14:34 -0500
X-Greylist: delayed 1691 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Feb 2007 00:14:33 EST
Date: Sun, 18 Feb 2007 23:46:16 -0500
From: Yaroslav Halchenko <kernel@onerussian.com>
To: linux-kernel@vger.kernel.org
Message-ID: <20070219044616.GC25659@washoe.onerussian.com>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-URL: http://www.onerussian.com
X-Image-Url: http://www.onerussian.com/img/yoh.png
X-PGP-Key: http://www.onerussian.com/gpg-yoh.asc
X-fingerprint: 3BB6 E124 0643 A615 6F00  6854 8D11 4563 75C0 24C8
User-Agent: mutt-ng/devel-r804 (Debian)
X-SA-Exim-Connect-IP: 192.168.100.6
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: yoh@washoe.rutgers.edu
Subject: no backlight on radeon after recent kernel "upgrade"s
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on smtp.onerussian.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kernel Developers,

Since the most recent successful for me kernel 2.6.19-rc6-mm1, I've
tried few times to build more recent snapshots and now finally
2.6.20-mm2. In all those cases I have a sad outcome -- kernel boots but
at some point during boot (few moments after Penguin icon in the top left
corner appears), light turns off... I still can see something, especially
if I light a strong flashlight at a sharp angle.

I've enabled back-light support and lcd support for those unsuccessful
kernels (with all backlight support features disabled kernel boots
ok and backlight shines as bright as always)

All my changes of values for files under
/sys/class/backlight/radeonbl0
had no impact on the screen. Also I had no files under /sys/class/lcd.

Running 
radeontool light off
caused complete turning off of LCD - I could not see
anything anymore.

sony's spictl -b had no effect as well.

Config can be found at
http://www.onerussian.com/Linux/bugs/nobacklight.1/config-2.6.20-mm2
lshw
http://www.onerussian.com/Linux/bugs/nobacklight.1/lshw
other details are available from
http://www.onerussian.com/Linux/bugs/nobacklight.1/

Could you please advise?
-- 
Yaroslav Halchenko
Research Assistant, Psychology Department, Rutgers-Newark
Student  Ph.D. @ CS Dept. NJIT
Office: (973) 353-5440x263 | FWD: 82823 | Fax: (973) 353-1171
        101 Warren Str, Smith Hall, Rm 4-105, Newark NJ 07102
WWW:     http://www.linkedin.com/in/yarik        
