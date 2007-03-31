Return-Path: <linux-kernel-owner+w=401wt.eu-S1751549AbXCaIdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbXCaIdl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 04:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbXCaIdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 04:33:41 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:35585 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbXCaIdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 04:33:40 -0400
Message-Id: <20070331083149.997762000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Sat, 31 Mar 2007 01:31:50 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/5] x86_64: enable clockevents and dynticks
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This series converts x86_64 timers to clockevents drivers
and then enables dynticks.  There's some minor cleanups along
the way.  The lapic broadcast mechanism is untested, I'm sure it
still needs work, there's still some cruft in lapic_setup_timer.

This is just for comments at this point, now that it's working
on my test box in both NO_HZ=n and NO_HZ=n configurations (typically
using hpet).

thanks,
-chris
--
