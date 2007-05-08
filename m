Return-Path: <linux-kernel-owner+w=401wt.eu-S934782AbXEHJkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934782AbXEHJkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934647AbXEHJkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:40:37 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:49319 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934646AbXEHJkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:40:36 -0400
Date: Tue, 8 May 2007 02:39:57 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Wright <chrisw@sous-sol.org>, LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86-64 highres/dyntick support
Message-ID: <20070508093957.GS3505@sequoia.sous-sol.org>
References: <1178485128.31213.98.camel@localhost.localdomain> <20070507163110.GP3505@sequoia.sous-sol.org> <1178556361.3042.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178556361.3042.16.camel@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> On Mon, 2007-05-07 at 09:31 -0700, Chris Wright wrote:
> >   Going through to see where we differ and if there's
> > any bits of my set that yours needs.  
> 
> Yes please.

OK, looks very similar all things considered.  One thing I didn't do
was fix lapic timer calibration (was hoping you'd do that part, and you
did ;-)  I've noticed that something has changed and I'm seeing irq0
handled on cpu3 (4 cpu system), where it used to be on cpu0 as expected.
In addition lapic timer is firing there, and I'm seeing a higher
interrupt load than I used to.  This is the same in your set and mine.
Following is small set of patches that were the more obvious bits.

thanks,
-chris
