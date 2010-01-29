Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224Ab0A2WHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab0A2WHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 17:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523Ab0A2WHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 17:07:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:37461 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab0A2WHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 17:07:05 -0500
Date: Fri, 29 Jan 2010 14:07:21 -0800
From: Greg KH <gregkh@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 07/10] usb: gadgetfs: Convert semaphore to mutex
Message-ID: <20100129220721.GA19935@suse.de>
References: <20100129203549.526478432@linutronix.de> <20100129203613.628793121@linutronix.de> <20100129211410.GB7265@suse.de> <alpine.LFD.2.00.1001292248180.5926@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001292248180.5926@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 10:48:36PM +0100, Thomas Gleixner wrote:
> On Fri, 29 Jan 2010, Greg KH wrote:
> 
> > On Fri, Jan 29, 2010 at 08:38:59PM -0000, Thomas Gleixner wrote:
> > > The semaphore data->lock is semantically a mutex. Convert it to a real
> > > mutex.
> > > 
> > > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Can you take that via your usb tree or do you want me to push it
> linuswards for .34 ?

I tried to do this last time the patches were posted, but the core mutex
changes were not in Linus's tree yet, so I could not as it broke my
build.

Has this changed?  If so, I would be glad to do so.  If not, I can't :(

thanks,

greg k-h
