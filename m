Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbYBXTHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbYBXTHf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 14:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYBXTH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 14:07:28 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:34791 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752965AbYBXTH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 14:07:28 -0500
To: linux-kernel@vger.kernel.org
Subject: CONFIG_FAIR_GROUP_SCHED: setting sched_min_bal_int_shares to 2000?
From: "Theodore Ts'o" <tytso@MIT.EDU>
Phone: (781) 391-3464
Message-Id: <E1JTMC3-0004V9-Vk@closure.thunk.org>
Date: Sun, 24 Feb 2008 14:07:23 -0500
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I recently enabled CONFIG_FAIR_GROUP_SCHED just to play with it, and I
noticed by default it causes a fair number of wakeups when running on
battery.   A quick read-through of the sources showed that this could
easily be fixed by doing:

echo 2000 > /proc/sys/kernel/sched_min_bal_int_shares

Aside from mostly disabling the CPU load balancing, is this likely to
cause any massive problems?

Any reason why we shouldn't perhaps do this automatically when we run on
battery (not necessarily as a kernel thing, but as a userspace policy
measure)?

Thanks,

					- Ted
