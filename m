Return-Path: <linux-kernel-owner+w=401wt.eu-S1761661AbZLJTqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761661AbZLJTqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:46:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761570AbZLJTqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:46:10 -0500
Received: from mx2.compro.net ([12.186.155.4]:15495 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761568AbZLJTqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:46:09 -0500
X-IronPort-AV: E=Sophos;i="4.47,376,1257138000"; 
   d="scan'208";a="4764941"
Message-ID: <4B215007.4030703@compro.net>
Date: Thu, 10 Dec 2009 14:46:15 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Unable to format or use floppies since 2.6.28
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have many boxes. They all do the same thing. Running different versions of SuSE, 10.3-11.2. Any kernel at or above 2.6.28 fails to fdformat a floppy. These same machines, using the same floppies and drives, running kernels older than 2.6.28 work just fine. I googled and found other such reports but no solution. I know better than to just assume it's a kernel bug but it sure looks like it could be so I'm inquiring about it here. 


# fdformat /dev/fd0u1440
Double-sided, 80 tracks, 18 sec/track. Total capacity 1440 kB.
Formatting ... done
Verifying ... Problem reading cylinder 1, expected 18432, read 2048


dmesg from 2.6.32:

Dec 10 14:24:21 harley kernel: end_request: I/O error, dev fd0, sector 45
Dec 10 14:24:21 harley kernel: Buffer I/O error on device fd0, logical block 5
Dec 10 14:24:23 harley kernel: end_request: I/O error, dev fd0, sector 72
Dec 10 14:24:23 harley kernel: Buffer I/O error on device fd0, logical block 9
Dec 10 14:24:26 harley kernel: end_request: I/O error, dev fd0, sector 117
Dec 10 14:24:26 harley kernel: Buffer I/O error on device fd0, logical block 14
Dec 10 14:24:28 harley kernel: end_request: I/O error, dev fd0, sector 127
Dec 10 14:24:28 harley kernel: Buffer I/O error on device fd0, logical block 15
Dec 10 14:24:30 harley kernel: end_request: I/O error, dev fd0, sector 45
Dec 10 14:24:30 harley kernel: Buffer I/O error on device fd0, logical block 5
Dec 10 14:24:32 harley kernel: end_request: I/O error, dev fd0, sector 144
Dec 10 14:24:32 harley kernel: Buffer I/O error on device fd0, logical block 18
Dec 10 14:24:34 harley kernel: end_request: I/O error, dev fd0, sector 189
Dec 10 14:24:34 harley kernel: Buffer I/O error on device fd0, logical block 23
Dec 10 14:24:36 harley kernel: end_request: I/O error, dev fd0, sector 216
Dec 10 14:24:36 harley kernel: Buffer I/O error on device fd0, logical block 27
Dec 10 14:24:39 harley kernel: end_request: I/O error, dev fd0, sector 261
Dec 10 14:24:39 harley kernel: Buffer I/O error on device fd0, logical block 32
Dec 10 14:24:41 harley kernel: end_request: I/O error, dev fd0, sector 288
Dec 10 14:24:41 harley kernel: Buffer I/O error on device fd0, logical block 36
Dec 10 14:24:43 harley kernel: end_request: I/O error, dev fd0, sector 333
Dec 10 14:24:43 harley kernel: Buffer I/O error on device fd0, logical block 41
Dec 10 14:24:45 harley kernel: end_request: I/O error, dev fd0, sector 360
Dec 10 14:24:45 harley kernel: Buffer I/O error on device fd0, logical block 45


# rpm -qf /usr/sbin/fdformat
util-linux-2.16-4.5.1.i586

Again, on this very machine, running 2.6.27.41 all is fine....

Thanks in advance
Mark
