Return-Path: <linux-kernel-owner+w=401wt.eu-S1751249Ab0A3FbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249Ab0A3FbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 00:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117Ab0A3FbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 00:31:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab0A3FbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 00:31:18 -0500
Date: Fri, 29 Jan 2010 21:26:49 -0800
From: Greg KH <gregkh@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 08/10] drivers/base: Convert dev->sem to mutex
Message-ID: <20100130052649.GA22459@suse.de>
References: <20100129203549.526478432@linutronix.de> <20100129203613.665951035@linutronix.de> <20100129211358.GA7265@suse.de> <alpine.LFD.2.00.1001292246580.5926@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001292246580.5926@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 10:48:08PM +0100, Thomas Gleixner wrote:
> On Fri, 29 Jan 2010, Greg KH wrote:
> 
> > On Fri, Jan 29, 2010 at 08:39:02PM -0000, Thomas Gleixner wrote:
> > > The semaphore is semantically a mutex. Convert it to a real mutex and
> > > clean up all users outside of drivers/base as well.
> > > 
> > > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Can you take that via your drivers tree or do you want me to push it
> linuswards for .34 ?

I will take it.

thanks,

greg k-h
