Return-Path: <linux-kernel-owner+w=401wt.eu-S1751712AbXBKD2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbXBKD2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 22:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbXBKD2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 22:28:42 -0500
Received: from brick.kernel.dk ([62.242.22.158]:7296 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbXBKD2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 22:28:41 -0500
Date: Sun, 11 Feb 2007 04:28:58 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: current git breaks resume
Message-ID: <20070211032858.GF6458@kernel.dk>
References: <20070209190307.GC6152@kernel.dk> <20070210112457.GK6152@kernel.dk> <20070210115018.GA3877@kernel.dk> <200702101257.32559.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702101257.32559.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10 2007, Rafael J. Wysocki wrote:
> On Saturday, 10 February 2007 12:50, Jens Axboe wrote:
> > On Sat, Feb 10 2007, Jens Axboe wrote:
> > > On Sat, Feb 10 2007, Rafael J. Wysocki wrote:
> > > > Hi,
> > > > 
> > > > On Friday, 9 February 2007 20:03, Jens Axboe wrote:
> > > > > Hi,
> > > > > 
> > > > > Unfortunately I'm a little short on time as I'll be travelling tomorrow,
> > > > > but of course preparing a new kernel for the laptop is something you
> > > > > want to do right before leaving. So I discovered that the current (well
> > > > > as of yesterday, HEAD is 5986a2ec35836a878350c54af4bd91b1de6abc59)
> > > > > doesn't resume on my x60. 2.6.20 works fine, so something broke since
> > > > > then.
> > > > 
> > > > I think the patch from
> > > > 
> > > > http://marc.theaimsgroup.com/?l=linux-acpi&m=117103448629685&w=2
> > > > 
> > > > is likely to help.
> > > 
> > > Thanks, will give it a shot.
> > 
> > Doesn't work, still hangs in the same way.
> 
> Well, looked promising ...
> 
> Still, I suspect the ACPI changes cause the problem to happen.
> 
> I've tested 2.6.20-git4 and it works on  my box (HPC nx6325, x86_64).
> Unfortunately I have no i386 setup anywhere close to me right now.

When I'm on stable ground again, I'll try with pm tracing and see if
that yields anything. Otherwise I'll do a bisect.

-- 
Jens Axboe

