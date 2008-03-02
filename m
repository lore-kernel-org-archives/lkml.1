Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbYCBJze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbYCBJze (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 04:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYCBJzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 04:55:25 -0500
Received: from www.tglx.de ([62.245.132.106]:47410 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbYCBJzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 04:55:24 -0500
Date: Sun, 2 Mar 2008 10:54:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <greg@kroah.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/2] object debugging infrastructure
In-Reply-To: <20080302052007.GA24573@kroah.com>
Message-ID: <alpine.LFD.1.00.0803021051020.11084@apollo.tec.linutronix.de>
References: <20080301100019.640027768@linutronix.de> <20080302052007.GA24573@kroah.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Mar 2008, Greg KH wrote:
> On Sat, Mar 01, 2008 at 10:24:52AM -0000, Thomas Gleixner wrote:
> > We can see an ever repeating problem pattern with objects of any kind in
> > the kernel:
> > 
> > 1) free of active objects
> > 2) reinitialization of active objects
> 
> Ah, this looks nice.  For kobjects I would like to track the above, as
> well as:
> 	- use of initialized objects
> 	- use of "freed" objects
> 	- objects that are never destroyed, yet the code controlling
> 	  them thinks they are.
> 
> I say "freed" as sometimes kobjects are in static structures and are not
> in memory that ends up being kfree() so slab poisoning doesn't help.

Good point. I try to come up with the infrastructure for that.

> Do you think that would be able to worked into this framework?  At first
> glance, it seems like it would be easy to add, but would like to make
> sure.

Yes, that should be possible

> If so, I'll gladly add this to the kobjects to help with issues there.

kobjects came to my mind as well, when I was thinking about possible
use cases.

Thanks,

	tglx
