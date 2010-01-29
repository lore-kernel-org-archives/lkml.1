Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007Ab0A2XFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab0A2XFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 18:05:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626Ab0A2XFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 18:05:10 -0500
Received: from www.tglx.de ([62.245.132.106]:60794 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785Ab0A2XFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 18:05:09 -0500
Date: Sat, 30 Jan 2010 00:04:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <gregkh@suse.de>
cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 07/10] usb: gadgetfs: Convert semaphore to mutex
In-Reply-To: <20100129220721.GA19935@suse.de>
Message-ID: <alpine.LFD.2.00.1001300003470.5926@localhost.localdomain>
References: <20100129203549.526478432@linutronix.de> <20100129203613.628793121@linutronix.de> <20100129211410.GB7265@suse.de> <alpine.LFD.2.00.1001292248180.5926@localhost.localdomain> <20100129220721.GA19935@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jan 2010, Greg KH wrote:

> On Fri, Jan 29, 2010 at 10:48:36PM +0100, Thomas Gleixner wrote:
> > On Fri, 29 Jan 2010, Greg KH wrote:
> > 
> > > On Fri, Jan 29, 2010 at 08:38:59PM -0000, Thomas Gleixner wrote:
> > > > The semaphore data->lock is semantically a mutex. Convert it to a real
> > > > mutex.
> > > > 
> > > > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > > > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > > 
> > > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > Can you take that via your usb tree or do you want me to push it
> > linuswards for .34 ?
> 
> I tried to do this last time the patches were posted, but the core mutex
> changes were not in Linus's tree yet, so I could not as it broke my
> build.
> 
> Has this changed?  If so, I would be glad to do so.  If not, I can't :(

The two patches have no dependencies on anything else. They just
convert to the existing mutex infrastructure.

Thanks,

	tglx
