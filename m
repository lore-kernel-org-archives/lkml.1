Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbYCPODH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbYCPODH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 10:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYCPOCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 10:02:55 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:33802 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861AbYCPOCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 10:02:46 -0400
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Anders Eriksson <aeriksson@fastmail.fm>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4 
In-reply-to: <200803101504.17219.bzolnier@gmail.com> 
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803101336.56159.bzolnier@gmail.com> <200803101410.27877.rjw@sisk.pl> <200803101504.17219.bzolnier@gmail.com>
Comments: In-reply-to Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
   message dated "Mon, 10 Mar 2008 15:04:17 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sun, 16 Mar 2008 15:01:18 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080316140118.891732DC044@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1JatRW-00046Y-8U.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1JatRW-00046Y-8U ee5e3661440473de1325d0beb22ceb7b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Many bisects later, now with taking care of making 'make oldconfig' off a 
known good config for each iteration, and doing 10 reboots and 5 smartd 
invocations for each version deemed good (not that anyone failed midway).

4d977e43d8ae758434e603cf2455d955f71c77c4 is first bad commit
commit 4d977e43d8ae758434e603cf2455d955f71c77c4
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sat Jan 26 20:13:12 2008 +0100

    ide: check BUSY and ERROR status bits before reading data in drive_cmd_intr()

    Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

:040000 040000 0fda2eb7d96335061741d7f54ed3e05ca34ac5b8 cebc540d20784168d04c159b92bd479593d8c9e8 M      drivers



