Return-Path: <linux-kernel-owner+w=401wt.eu-S1762032AbZJJRK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762032AbZJJRK6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 13:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762000AbZJJRK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 13:10:58 -0400
Received: from www.tglx.de ([62.245.132.106]:56807 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761979AbZJJRK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 13:10:57 -0400
Date: Sat, 10 Oct 2009 19:09:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jean Delvare <khali@linux-fr.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 23/28] i2c: Remove big kernel lock from i2cdev_open
In-Reply-To: <20091010190436.1a48f98e@hyperion.delvare>
Message-ID: <alpine.LFD.2.00.0910101907420.9428@localhost.localdomain>
References: <20091010153314.827301943@linutronix.de> <20091010153350.006406413@linutronix.de> <20091010190436.1a48f98e@hyperion.delvare>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean,

On Sat, 10 Oct 2009, Jean Delvare wrote:
> Looks good to me:
> 
> Acked-by: Jean Delvare <khali@linux-fr.org>
> 
> Do you want me to pick this patch in my i2c tree, or will you take care
> of pushing it upstream? If you're not going to push it quickly, I'd
> prefer the first solution, to avoid conflicts.

I'm targeting for .33, but please pick it up. I drop it from my queue
then.

> (As a side note, i2c-dev would deserve a partial rewrite as it doesn't
> integrate into the standard device driver model, and certainly has a
> number of race conditions. But this is well beyond the scope of your
> patch.)

Yeah, noticed that this code needs some care, but my current dosis of
brain wreckage with the BKL stuff is enough :)

Thanks,

	tglx
