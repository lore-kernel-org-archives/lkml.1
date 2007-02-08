Return-Path: <linux-kernel-owner+w=401wt.eu-S1423494AbXBHWb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423494AbXBHWb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 17:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423495AbXBHWb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 17:31:59 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:50079 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423494AbXBHWb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 17:31:58 -0500
Message-ID: <45CBA41D.3000406@garzik.org>
Date: Thu, 08 Feb 2007 17:28:45 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, hjlipp@web.de, tilman@imap.cc
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: gigaset build broken on current linux-2.6.git
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fedora Core 6, x86-64, make allyesconfig:

[jgarzik@pretzel linux-2.6]$ make -sj4
   CHK     include/linux/version.h
   CHK     include/linux/utsrelease.h
   CHK     include/linux/compile.h
drivers/isdn/gigaset/bas-gigaset.c: In function ‘dump_urb’:
drivers/isdn/gigaset/bas-gigaset.c:258: error: ‘struct urb’ has no 
member named ‘bandwidth’
make[3]: *** [drivers/isdn/gigaset/bas-gigaset.o] Error 1
make[2]: *** [drivers/isdn/gigaset] Error 2
make[1]: *** [drivers/isdn] Error 2

