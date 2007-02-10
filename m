Return-Path: <linux-kernel-owner+w=401wt.eu-S933440AbXBJMAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440AbXBJMAJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 07:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933390AbXBJL7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:59:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33129 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946833AbXBJL7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:59:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: current git breaks resume
Date: Sat, 10 Feb 2007 12:57:31 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070209190307.GC6152@kernel.dk> <20070210112457.GK6152@kernel.dk> <20070210115018.GA3877@kernel.dk>
In-Reply-To: <20070210115018.GA3877@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702101257.32559.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 10 February 2007 12:50, Jens Axboe wrote:
> On Sat, Feb 10 2007, Jens Axboe wrote:
> > On Sat, Feb 10 2007, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > On Friday, 9 February 2007 20:03, Jens Axboe wrote:
> > > > Hi,
> > > > 
> > > > Unfortunately I'm a little short on time as I'll be travelling tomorrow,
> > > > but of course preparing a new kernel for the laptop is something you
> > > > want to do right before leaving. So I discovered that the current (well
> > > > as of yesterday, HEAD is 5986a2ec35836a878350c54af4bd91b1de6abc59)
> > > > doesn't resume on my x60. 2.6.20 works fine, so something broke since
> > > > then.
> > > 
> > > I think the patch from
> > > 
> > > http://marc.theaimsgroup.com/?l=linux-acpi&m=117103448629685&w=2
> > > 
> > > is likely to help.
> > 
> > Thanks, will give it a shot.
> 
> Doesn't work, still hangs in the same way.

Well, looked promising ...

Still, I suspect the ACPI changes cause the problem to happen.

I've tested 2.6.20-git4 and it works on  my box (HPC nx6325, x86_64).
Unfortunately I have no i386 setup anywhere close to me right now.

Greetings,
Rafael
