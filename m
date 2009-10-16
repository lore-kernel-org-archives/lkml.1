Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbZJPIJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbZJPIJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 04:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbZJPIJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 04:09:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:51970 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755434AbZJPIJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 04:09:55 -0400
X-Authenticated: #2220048
X-Provags-ID: V01U2FsdGVkX19gnJprU2Ng5FoDc59vtEoSV1VQJV4aUMh+EGPipk
	yKEvIebVLrl4hS
Subject: mISDN v2 fails on 32bit userspace system with 64bit kernel
From: Alexander Naumann <alexandernaumann@gmx.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 16 Oct 2009 10:09:07 +0200
Message-Id: <1255680547.3362.245.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am running a 64bit kernel (2.6.28.10 or 2.6.30.1) on a 32bit userspace.
I have recognized that mISDN is not working in this mode (if I am using
32/32 mode everything is fine).

Logs tell me that ioctl calls fail.
It seems that they are not compatible running in mix mode (I did not
test pur 64 bit mode).


I have used mISDN-drivers (v2) from kernel (2.6.28.10, 2.6.30 and
2.6.31.2) and tried to start mISDNuser tools:

A socket connection is established but every socket connection through
ioctl is going to fail.

"Oct 14 14:51:20 localhost kernel: ioctl32(misdnportinfo:8098): Unknown cmd fd(3) cmd(80044943){t:'I';sz:4} arg(ffa7b5b4) on socket:[107121]"

At the isdn4linux mailing list I have read some months ago that it is also not working with a pur 64 bit system.

Is anybody able and willing to work on this problem?

Thanks for help

Alex




