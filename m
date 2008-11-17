Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbYKQJhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbYKQJhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 04:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbYKQJgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 04:36:52 -0500
Received: from cpsmtpo-eml05.KPNXCHANGE.COM ([213.75.38.154]:12413 "EHLO
	cpsmtpo-eml05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752832AbYKQJgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 04:36:51 -0500
From: Frans Pop <elendil@planet.nl>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug 11905] REGRESSION: lots of extra timer interrupts costing power
Date: Mon, 17 Nov 2008 10:36:48 +0100
User-Agent: KMail/1.9.9
Cc: eo@nebensachen.de, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       mingo@elte.hu, bugme-daemon@bugzilla.kernel.org,
       akpm@linux-foundation.org
References: <E1KvN6w-0002QE-E3@closure.thunk.org> <20081031031516.GA9781@mit.edu> <87mygl2hg1.fsf@denkblock.local> <87mygl2hg1.fsf@denkblock.local> <20081117081326.GA14523@mit.edu>
In-reply-To: <20081117081326.GA14523@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811171036.49067.elendil@planet.nl>
X-OriginalArrivalTime: 17 Nov 2008 09:36:49.0471 (UTC) FILETIME=[03EAACF0:01C94898]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> Hi, what's going on with this regression?  To refresh people's memory,
> I tracked down the excess interrupts to a specific commit, fb02fbc1,
> and I've been running quite happily with a patch to revert this
> commit.

Isn't that solved by this commit (included in -rc5)?

commit ae99286b4f1be7788f2d6947c66a91dbd6351eec
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon Nov 10 13:20:23 2008 +0100

    nohz: disable tick_nohz_kick_tick() for now
