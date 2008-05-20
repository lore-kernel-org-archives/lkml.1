Return-Path: <linux-kernel-owner+w=401wt.eu-S933141AbYETT6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141AbYETT6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 15:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758854AbYETT6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 15:58:16 -0400
Received: from smtpgpe.resot.net ([217.175.160.71]:45076 "EHLO smtpgpe.ool.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758538AbYETT6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 15:58:16 -0400
From: "werner" <werner@sys-linux.yi.org>
Subject: 2.6.26-rcX: Problem with mem config > 4GB ; fore2000 atm driver options
To: linux-kernel@vger.kernel.org
X-Originating-IP: 217.175.173.200
X-Mailer: Usermin 1.340
Message-Id: <1211312990.4898@sys-linux.yi.org>
Date: Tue, 20 May 2008 16:49:50 -0300 (GFT)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1211312990"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--bound1211312990
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

I observed the following problems with 2.6.26-rcX-gitY:

Steady-steady I got segmentation faults. On 2.6.25.4 no problems.  I compiled plenty times the newer kernels to find out the reason.   I thing the problem is the memory configuration as > 4 GB.  In my config file, since earlier kernels, i configured >4 GB. When I use  config files with that, then occure the problems, with <4 GB not. It seems that the menuconfig of the new kernels accept only until 4 GB.

Another problem with the fore2000 atm configuration. When one affirms the default config of menuconfig, then the compilation crashs because it wouldn't find the path of these drivers. When one explicitely click  x  , affirming the default path (what would be default anyway) then the compilation works.   This seems to be an error of the menuconfig and should be corrected


W.Landgraf

SYS
0.23-rc1  20/5/08

--bound1211312990--

