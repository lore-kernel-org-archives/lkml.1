Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbYKWQaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbYKWQaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 11:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbYKWQaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 11:30:06 -0500
Received: from hpsmtp-eml20.KPNXCHANGE.COM ([213.75.38.85]:47828 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837AbYKWQaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 11:30:04 -0500
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #12064] [regression] Measured 688 cycles TSC warp; marking TSC unstable
Date: Sun, 23 Nov 2008 17:29:58 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera> <vyitTh0pP2N.A.d2B.M7HKJB@chimera>
In-Reply-To: <vyitTh0pP2N.A.d2B.M7HKJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811231729.59256.elendil@planet.nl>
X-OriginalArrivalTime: 23 Nov 2008 16:30:02.0075 (UTC) FILETIME=[BBF052B0:01C94D88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 November 2008, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12064
> Date		: 2008-11-16 19:27:43 (7 days old)
> References	: http://marc.info/?l=linux-kernel&m=122686370308852&w=2

Looks to be fixed in -rc6:

-Calibrating delay using timer specific routine.. 6198.05 BogoMIPS (lpj=12396107)
+Calibrating delay using timer specific routine.. 6399.82 BogoMIPS (lpj=12799647)
[...]
-checking TSC synchronization [CPU#0 -> CPU#1]:
-Measured 696 cycles TSC warp between CPUs, turning off TSC clock.
-Marking TSC unstable due to check_tsc_sync_source failed
+checking TSC synchronization [CPU#0 -> CPU#1]: passed.

So, BogoMIPS value on CPU#1 is in line with CPU#0 again and TSC passes.
No idea what commit would be responsible.

Cheers,
FJP
