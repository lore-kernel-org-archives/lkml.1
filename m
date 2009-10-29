Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbZJ2I5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbZJ2I5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbZJ2I5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:57:51 -0400
Received: from brick.kernel.dk ([93.163.65.50]:55721 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbZJ2I5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:57:51 -0400
Date: Thu, 29 Oct 2009 09:57:55 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alex Chiang <achiang@hp.com>
Cc: Mark Lord <lkml@rtr.ca>, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
Message-ID: <20091029085755.GB10727@kernel.dk>
References: <20091012150603.GK9228@kernel.dk> <20091012214854.GA14102@ldl.fc.hp.com> <20091013082903.GQ9228@kernel.dk> <20091013172731.GB22797@ldl.fc.hp.com> <20091014081309.GM9228@kernel.dk> <20091020190707.GA25615@ldl.fc.hp.com> <20091026105419.GA10727@kernel.dk> <20091027024841.GA30509@ldl.fc.hp.com> <20091027082635.GS10727@kernel.dk> <20091028213948.GC8749@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028213948.GC8749@ldl.fc.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28 2009, Alex Chiang wrote:
> * Jens Axboe <jens.axboe@oracle.com>:
> > 
> > acpiphp: enable_slot - physical_slot = 1
> > power_on_slot
> >   no _PS0
> >   no _PS0
> >   no _PS0
> >   no _PS0
> >   no _PS0
> >   no _PS0
> >   no _PS0
> >   no _PS0
> 
> One final thought -- your DSDT doesn't provide any power methods
> such as _PS[0-3] (I grepped your DSDT so basing my statement on
> more than just the output above), and without those, I'm pretty
> sure that there's no way for the OS to communicate to the BIOS
> that we want to power those slots on.
> 
> So, something funky is going on with your BIOS. This isn't some
> weird proto board or something, is it? ;)

It's pre-production, but not a prototype. I'll take it up with the
vendor.

-- 
Jens Axboe

