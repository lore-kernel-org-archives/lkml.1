Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbYEWRxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbYEWRxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYEWRxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:53:36 -0400
Received: from smtpgpe.resot.net ([217.175.160.71]:54223 "EHLO smtpgpe.ool.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757527AbYEWRxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:53:33 -0400
From: "werner" <werner@copaya.yi.org>
Subject: EDD problem -- regression -- crash on booting by probing EDD
To: linux-kernel@vger.kernel.org
X-Originating-IP: 217.175.174.222
X-Mailer: Usermin 1.340
Message-Id: <1208793757.26711@copaya.yi.org>
Date: Mon, 21 Apr 2008 13:02:38 -0300 (GFT)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1208793758"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--bound1208793758
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

The problem below , I continued to check, and it seems really be a kernel bug (inclusively that the option edd=off don't work)

Because of this, I had to release an update of my SYS distro DVD, with i=installation using the normal 2.6.25 kernel, and a=alternatively 2.4.24-rc6-git2 what dont have that problem.  ftp://ftp5.gwdg.de/pub/linux/install/sys/  

The problem happened with an ACER Aspire 7004WSMi laptop.   

Werner Landgraf


=====================================================================================
There is a regression in 2.6.25.   Booting stops with: Probing EDD (edd=off to disable) message.

It dont work the kernel boot parameter edd=off .  With pci=off the computer continues to boot, but later it dont find hard disks etc.

Thats happening on 2.6.25   definitive, but was verified to go back until 2.6.24-rc6-git8, but it wasnt yet at 2.6.24-rc6-git2 which worked correctly.


Werner Landgraf

SYS Linux

http://linux.softpedia.com/get/System/Operating-Systems/Linux-Distributions/SYS-34168.shtml

--bound1208793758--

