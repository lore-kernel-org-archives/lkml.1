Return-Path: <linux-kernel-owner+w=401wt.eu-S1752007AbYCOEEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbYCOEEZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 00:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750726AbYCOEEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 00:04:16 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43339 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbYCOEEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 00:04:15 -0400
Subject: [PATCH 0/5] time/ntp changes
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 21:04:12 -0700
Message-Id: <1205553852.6122.76.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've re-based my timekeeping patch queue ontop of Roman's recent NTP and
div64 patches. I've been a little short on time, so I've not been able
to get them all tested (ntp testing takes a number of hours), but they
do build and I wanted to get some feedback on the re-base.

My apologies to Ingo for sitting on his patches for this long.

I'll get a test setup going over the weekend to make sure all is well.

The total patch queue is large, so while folks probably won't try it
themselves, here's the full series I'm using to build:

#start w/ linus' -git

#roman's udiv patches
01-udiv.patchd
02-convert.patch
03-remove.patch

#roman's ntp changes
1-cleanup.patch
2-ntp4.patch
3-timefreq.patch
4-timeoffset.patch
5-tai.patch
6-scaleshift.patch
7-ticklength.patch
8-leap.patch

#my timekeeping changes
mult-adj-split.patch
monotonic-raw

#ntp cleanups from Ingo and me
ntp-cleanup-ingo1.patch
ntp-cleanup-ingo2.patch
ntp_cleanup-john.patch


