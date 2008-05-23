Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbYEWP7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbYEWP7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbYEWP7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:59:25 -0400
Received: from smtpgpe.resot.net ([217.175.160.71]:51069 "EHLO smtpgpe.ool.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbYEWP7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:59:24 -0400
From: "werner" <werner@sys-linux.yi.org>
Subject: 2.6.26-rcX: Problem with mem config > 4GB ; fore2000 atm driver options  --  addition
To: linux-kernel@vger.kernel.org
X-Originating-IP: 217.175.173.180
X-Mailer: Usermin 1.340
Message-Id: <1211557898.4751@sys-linux.yi.org>
Date: Fri, 23 May 2008 12:51:38 -0300 (GFT)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1211557898"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--bound1211557898
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

My original reclamation was, that, starting with a config file with memory > 4 GB what was working until now,  with 2.6.26-rcX-gitY i got segmentation faults, so that I had to configure memory < 4 GB.

I was informed that meanwhile the error with the segmentation faults for memory > 4 GB was corrected.



Now I tried to compile 2.6.26-rc3-git5 , starting with my last config file what has memory < 4 GB because of the explained problem,   but I wanted to change that with menuconfig to memory > 4 GB as it was before, because my computer has 8 GB memory.

Now happens a next problem.  menuconfig don't permit, when you start with a config of < 4 GB, to change that to > 4 GB.    In the menu comes only the option until 4 GB, and in the resulting config file is 'memory until 64 GB'  disabled ...


Thus, even if the segmentation faults now are repaired, there remains, still, to repair the menuconfig program, so that, when one had < 4 GB configured, but want to change to > 4 GB, that this works.


2.6.26-rc3-git5 from this morning, configured with < 4 GB , until now runs without other problems on my server,  http://www.copaya.yi.org/info.php  .   Actualized binary .tgz packages of kernels what I compiled are always on the mirrors of my SYS distro, p.ex.: ftp://ftp5.gwdg.de/pub/linux/install/sys/  (and .../old)


Werner Landgraf


SYS  Linux
v. 0.23-rc1  20/5/08  with 2.6.26-rc3

--bound1211557898--

