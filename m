Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbXI2Nn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbXI2Nn4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 09:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbXI2Nns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 09:43:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:35051 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753062AbXI2Nns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 09:43:48 -0400
X-Authenticated: #31060655
X-Provags-ID: V01U2FsdGVkX1+0lXp5GZW05bipMkev+LnydD/Xk0bvXP7/zLHd9+
	E1CxD2WqR4kXd/
Message-ID: <46FE5701.2030000@gmx.net>
Date: Sat, 29 Sep 2007 15:45:37 +0200
From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070301 SUSE/1.0.9-1.3 SeaMonkey/1.0.9
MIME-Version: 1.0
To: spi-devel-general@lists.sourceforge.net
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: IT8716F SPI driver submission?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have written a rough code skeleton to be able to use the ITE IT8716F
Super I/O chip as SPI host/master. The code works fine in userspace, but
the Linux kernel SPI framework looks like it could save me from
implementing full support for SPI flash clients/slaves. That's why I'd
like to rewrite my code in a manner that's suitable for kernel inclusion.

The IT8716F accepts commands byte-wise and does all of the lifting on
the SPI bus as well. There are limitations, though:
- It can send 1,2,4,5 bytes (including command byte) to the slave and
read 0,1,2,3 bytes back. Other values are not possible.
- Bus clock rate is either 33 MHz or 16.5 MHz.

Is there any driver I can start from as reference?

Regards,
Carl-Daniel
