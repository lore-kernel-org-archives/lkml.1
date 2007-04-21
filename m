Return-Path: <linux-kernel-owner+w=401wt.eu-S1030319AbXDUH6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030319AbXDUH6L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 03:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030468AbXDUH6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 03:58:10 -0400
Received: from mail01.syd.optusnet.com.au ([211.29.132.182]:44862 "EHLO
	mail01.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030192AbXDUH6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 03:58:08 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>, Al Boldi <a1426z@gawab.com>,
       Peter Williams <pwil3058@bigpond.net.au>, Nick Piggin <npiggin@suse.de>,
       Matt Mackall <mpm@selenic.com>, Bill Huey <billh@gnuppy.monkey.org>,
       William Lee Irwin III <wli@holomorphy.com>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>
Subject: [ANNOUNCE] Staircase Deadline cpu scheduler version 0.44
Date: Sat, 21 Apr 2007 17:57:11 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704211757.12277.kernel@kolivas.org>
X-Length: 1518
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A significant bugfix for forking tasks was just posted, so here is an updated 
version of the staircase deadline cpu scheduler. This may cause noticeable
behavioural improvements under certain workloads (such as compiling software 
with make).

Thanks to Al Boldi for making me check the fork code!

http://ck.kolivas.org/patches/staircase-deadline/2.6.20.7-sd-0.44.patch
http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc7-sd-0.44.patch

Incrementals in
http://ck.kolivas.org/patches/staircase-deadline/2.6.20.7/
http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc7/

Renicing X to -10, while not essential, is preferable.

See the patch just posted called 'sched: implement staircase scheduler yaf 
fix' for full changelog.

-- 
-ck
