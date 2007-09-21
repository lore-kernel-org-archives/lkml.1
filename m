Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbXIUJj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbXIUJj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 05:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbXIUJjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 05:39:46 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1084 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbXIUJjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 05:39:45 -0400
Date: Fri, 21 Sep 2007 10:39:14 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Matthias Hensler <matthias@wspse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       richard kennedy <richard@rsk.demon.co.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: Processes spinning forever, apparently in lock_timer_base()?
Message-ID: <20070921093914.GB4750@shadowen.org>
References: <46B10BB7.60900@redhat.com> <20070803113407.0b04d44e.akpm@linux-foundation.org> <20070804084426.GA20464@kobayashi-maru.wspse.de> <20070809095943.GA7763@kobayashi-maru.wspse.de> <20070809095534.25ae1c42.akpm@linux-foundation.org> <46F2E103.8000907@redhat.com> <20070920142927.d87ab5af.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070920142927.d87ab5af.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This sounds an awful lot like the same problem I reported with fsck
hanging.  I believe that Hugh had a candidate patch for that, which was
related to dirty tracking limits.  It seems that that patch tested, and
acked by Peter.  All on lkml under:

	2.6.23-rc6-mm1 -- mkfs stuck in 'D'

-apw
