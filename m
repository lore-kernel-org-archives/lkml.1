Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbYA3Wky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbYA3Wky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 17:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757647AbYA3Wkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 17:40:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48499 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbYA3Wko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 17:40:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: [Regression] 2.6.24-git8 (and earlier): Multiple processes stuck in D states after logout from KDE
Date: Wed, 30 Jan 2008 23:38:24 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801302338.25365.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently I've been observing problems with unmounting the /home fs on reboot
and/or shutdown on two test boxes.

After some more investigation I've found that this is due to some KDE processes
stuck in D states after their owner has logged out.

This happens 100% of the time if there's a suspend/resume cycle before the user
logs out (ie. the user logs into KDE, works for some time, suspends the box to
RAM and resmes one or more times and then logs out).  Still, I also observe the
symptoms on a box that's never suspended.

I'm not sure how to debug this, so please advise.

Thanks,
Rafael
