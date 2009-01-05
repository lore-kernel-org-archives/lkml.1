Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbZAEThg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbZAEThg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZAETh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:37:27 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:26242 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbZAETh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:37:26 -0500
Subject: Re: [PATCH] ASPM: Use msleep instead of cpu_relax during link
 retraining
From: Andrew Patterson <andrew.patterson@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Pavel Machek <pavel@suse.cz>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       shaohua.li@intel.com
In-Reply-To: <200901051117.00683.jbarnes@virtuousgeek.org>
References: <20081222221156.29645.95982.stgit@bluto>
	 <20081225232427.GJ19967@parisc-linux.org> <20081226182702.GA1528@ucw.cz>
	 <200901051117.00683.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 12:40:12 -0700
Message-Id: <1231184412.18550.24.camel@bluto>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-05 at 11:17 -0800, Jesse Barnes wrote:
> On Friday, December 26, 2008 10:27 am Pavel Machek wrote:
> > On Thu 2008-12-25 16:24:27, Matthew Wilcox wrote:
> > > On Thu, Dec 25, 2008 at 08:01:29PM +0100, Pavel Machek wrote:
> > > > On Mon 2008-12-22 15:11:57, Andrew Patterson wrote:
> > > > > ASPM: Use msleep instead of cpu_relax during link retraining
> > > > >
> > > > > The cpu_relax() function can be a noop on certain architectures
> > > > > like IA-64 when CPU threads are disabled, so use msleep instead
> > > > > during link retraining busy/wait loop.
> > > >
> > > > Author clearly wanted to do a busy loop... why do you think 10msec
> > > > delay here is acceptable?
> > >
> > > 10ms?  I see a 1ms sleep.
> >
> > Yes... IIRC msleep will sleep for up-to 1/HZ on non-highres systems.
> >
> > > Yes, the subsequent test should be of reg16 instead of jiffies.
> 
> Andrew, care to send an updated patch which includes fixes for the issues 
> caught by Pavel & Matthew?
> 

Will do.

Andrew

> Thanks,

