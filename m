Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbXI1I2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbXI1I2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbXI1I2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:28:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50403 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174AbXI1I2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:28:15 -0400
Date: Fri, 28 Sep 2007 01:26:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: roel <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>,
       Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] spin_lock_unlocked cleanups
Message-Id: <20070928012656.0bae3991.akpm@linux-foundation.org>
In-Reply-To: <1190967450.18681.10.camel@chaos>
References: <46FC2245.50907@tiscali.nl>
	<1190967450.18681.10.camel@chaos>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 10:17:30 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:

> can we please add this to checkpatch.pl ? 
> 
> > -spinlock_t bpci_lock = SPIN_LOCK_UNLOCKED;
> > +DEFINE_SPINLOCK(bpci_lock);

That check is already in checkpatch.  Problem is that hardly anyone
runs the thing.

I think we're ready to wire checkpatch up to a email robot which monitors
the mailing lists and sends people nastygrams.  I bet that'll be popular ;)

(I'd love it if it could detect wordwrapped and tab-expanded patches, too. 
You wouldn't _believe_...)
