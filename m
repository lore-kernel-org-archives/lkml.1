Return-Path: <linux-kernel-owner+w=401wt.eu-S1423196AbXD3NZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423196AbXD3NZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 09:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423268AbXD3NZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 09:25:07 -0400
Received: from phoenix.bawue.net ([193.7.176.60]:45898 "EHLO mail.bawue.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423264AbXD3NZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 09:25:06 -0400
X-Greylist: delayed 1651 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Apr 2007 09:25:06 EDT
Date: Mon, 30 Apr 2007 14:52:00 +0200
From: Joerg Sommrey <jo@sommrey.de>
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.21: pmtmr losing time
Message-ID: <20070430125200.GA5379@sommrey.de>
Mail-Followup-To: Joerg Sommrey <jo@sommrey.de>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

after switching to 2.6.21 the system clock sporadically loses time on my
box (i386, Athlon MP).
It's always around 4.68 seconds and happened 7 times in the last 12
hours.  A simple calculation (2 ^ ACPI_PM_MASK / PMTMR_TICKS_PER_SEC =
2 ^ 24 / 3579545 = 4.686968875) shows: There is almost exactly one
pmtmr-cycle missing.  Could this be caused by a pmtmr-wrap when the
system is in a sleep state? 

-jo

-- 
-rw-r--r-- 1 jo users 62 2007-04-29 22:29 /home/jo/.signature
