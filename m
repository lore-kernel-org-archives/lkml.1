Return-Path: <linux-kernel-owner+w=401wt.eu-S1763651AbXKNA4C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763651AbXKNA4C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:56:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760438AbXKNAzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:55:52 -0500
Received: from server145.serverhost2.com ([65.98.57.98]:36923 "EHLO
	server145.serverhost2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761011AbXKNAzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:55:51 -0500
X-Greylist: delayed 14840 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Nov 2007 19:55:51 EST
Message-ID: <1354.72.205.227.110.1194986901.squirrel@www.tuxsoft.com>
Date: Tue, 13 Nov 2007 15:48:21 -0500 (EST)
Subject: 2.6.24-rc2 displays incorrect DVD description
From: steve@tuxsoft.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server145.serverhost2.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [32404 32406] / [47 12]
X-AntiAbuse: Sender Address Domain - tuxsoft.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For example, 2.6.23.1:

Linux version 2.6.23.1 (root@jupiter) (gcc version 4.2.2) #1 SMP PREEMPT
Fri Oct 26 13:09:09 CDT 2007
kernel: hdd: HP DVD Writer 1040d, ATAPI CD/DVD-ROM drive
kernel: hdd: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache,
UDMA(66)

and

2.6.24-rc2:

Linux version 2.6.24-rc2 (ironman@jupiter) (gcc version 4.2.2) #1 SMP
PREEMPT Fri Nov 9 20:41:37 CST 2007
kernel: hdd: HP DVD Writer 1040d, ATAPI CD/DVD-ROM drive
kernel: hdd: ATAPI 126X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache,
UDMA(66)

The drive seems to work correctly, reading and writing just fine.  I just
happened to notice this and thought I'd pass it along.

One other odd thing while looking through the logs, 2.6.23.1 has also
reported the drive as follows:

Linux version 2.6.23.1 (root@jupiter) (gcc version 4.2.2) #1 SMP PREEMPT
Fri Oct 26 13:09:09 CDT 2007
kernel: hdd: HP DVD Writer 1040d, ATAPI CD/DVD-ROM drive
kernel: hdd: ATAPI 32X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache,
UDMA(66)

Any idea what is going on here?  It's being reported as 48X, 126X, and 32X.

Thanks,
Steve
