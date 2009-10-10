Return-Path: <linux-kernel-owner+w=401wt.eu-S933172AbZJJRkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172AbZJJRkG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 13:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760300AbZJJRkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 13:40:05 -0400
Received: from poutre.nerim.net ([62.4.16.124]:50315 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016AbZJJRkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 13:40:03 -0400
Date: Sat, 10 Oct 2009 19:39:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 23/28] i2c: Remove big kernel lock from i2cdev_open
Message-ID: <20091010193915.0e34f0e9@hyperion.delvare>
In-Reply-To: <alpine.LFD.2.00.0910101907420.9428@localhost.localdomain>
References: <20091010153314.827301943@linutronix.de>
	<20091010153350.006406413@linutronix.de>
	<20091010190436.1a48f98e@hyperion.delvare>
	<alpine.LFD.2.00.0910101907420.9428@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Oct 2009 19:09:45 +0200 (CEST), Thomas Gleixner wrote:
> Jean,
> 
> On Sat, 10 Oct 2009, Jean Delvare wrote:
> > Looks good to me:
> > 
> > Acked-by: Jean Delvare <khali@linux-fr.org>
> > 
> > Do you want me to pick this patch in my i2c tree, or will you take care
> > of pushing it upstream? If you're not going to push it quickly, I'd
> > prefer the first solution, to avoid conflicts.
> 
> I'm targeting for .33, but please pick it up. I drop it from my queue
> then.

Will do. I guess I can assume that the patch is from Vincent Sanders,
not you, despite the lack of From: header?

-- 
Jean Delvare
