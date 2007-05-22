Return-Path: <linux-kernel-owner+w=401wt.eu-S1765577AbXEVIlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765577AbXEVIlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbXEVIk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:40:59 -0400
Received: from aun.it.uu.se ([130.238.12.36]:63265 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185AbXEVIk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:40:58 -0400
From: Mikael Pettersson <mikpe@it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18002.44181.639121.720839@alkaid.it.uu.se>
Date: Tue, 22 May 2007 10:40:53 +0200
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUG sparc64] 2.6.22-rc broke X on Ultra5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just a FYI:

2.6.21 works fine on my Ultra5, but with 2.6.22-rc the X
server (from Aurora 2) fails to mmap() the PCI frame buffer
(atyfb).

I noticed a lot of PCI-related changes both in `dmesg' and
/var/log/Xorg.0.log between 2.6.21 and 2.6.22-rc, so my
guess is that PCI resources get broken somewhere.

I'll try a bisect between 2.6.21 and 2.6.22-rc1 next, but
I'm also willing to test patches in case anyone thinks they
know what the fix is.

/Mikael
