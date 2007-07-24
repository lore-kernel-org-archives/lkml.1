Return-Path: <linux-kernel-owner+w=401wt.eu-S1763324AbXGXRo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763324AbXGXRo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 13:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758899AbXGXRoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 13:44:39 -0400
Received: from disorder.primate.net ([198.144.194.12]:45776 "EHLO
	disorder.primate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758650AbXGXRoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 13:44:38 -0400
X-Greylist: delayed 1163 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jul 2007 13:44:38 EDT
Date: Tue, 24 Jul 2007 10:25:14 -0700
From: Aaron Porter <atporter@primate.net>
To: linux-kernel@vger.kernel.org
Subject: miserable performance of 2.6.21 under network load
Message-ID: <20070724172513.GB24543@primate.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


	I'm in the process up upgrading a pool of apache servers from
2.6.17.8 to 2.6.21.5, and we're seeing a pretty major change in behavior.
Under identical network load, 2.6.21 has a load average more than 3 times
higher, cpu 0 spends well over 90% of its time in interrupts (vs ~30%
under 2.6.17). When we hit 3k apache sessions, ksoftirqd eats 100% of cpu0
and our network traffic drops off rapidly. The end result is that 2.6.17
performs twice as well under this load.
