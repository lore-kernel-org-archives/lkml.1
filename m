Return-Path: <linux-kernel-owner+w=401wt.eu-S1751642AbXD0AAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbXD0AAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 20:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755290AbXD0AAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 20:00:41 -0400
Received: from [70.254.190.220] ([70.254.190.220]:41390 "EHLO server.willdawg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751642AbXD0AAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 20:00:16 -0400
Date: Fri, 27 Apr 2007 00:00:15 +0000 (GMT)
From: William Heimbigner <icxcnika@mar.tar.cc>
X-X-Sender: icxcnika@server.thyself
To: linux-kernel@vger.kernel.org
cc: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-2.6.21-rc7-mm2 fails to compile
Message-ID: <Pine.LNX.4.64.0704262358550.25153@server.thyself>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Output leading up to the error:

   CC      drivers/macintosh/macio-adb.o
   LD      drivers/macintosh/built-in.o
   CC [M]  drivers/macintosh/apm_emu.o
   CC [M]  drivers/macintosh/therm_windtunnel.o
drivers/macintosh/therm_windtunnel.c: In function 'therm_of_remove':
drivers/macintosh/therm_windtunnel.c:462: error: void value not ignored as it 
ought to be
drivers/macintosh/therm_windtunnel.c:463: warning: control reaches end of 
non-void function
make[2]: *** [drivers/macintosh/therm_windtunnel.o] Error 1
make[1]: *** [drivers/macintosh] Error 2
make: *** [drivers] Error 2

This is on an iMac G3 powerpc.

William Heimbigner
icxcnika@mar.tar.cc
