Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbYB0L1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbYB0L1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 06:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbYB0L1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 06:27:09 -0500
Received: from mail.gmx.net ([213.165.64.20]:45460 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753431AbYB0L1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 06:27:08 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+DtTJMpuCDcREhYlqm5h8bx0NjUEVhSNnPE3gErV
	DvvZXvYUXLsJPe
Date: Wed, 27 Feb 2008 12:27:18 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PCI] duplicate sysfs symbols getting registered in current git
In-Reply-To: <Pine.LNX.4.64.0802271222530.5059@axis700.grange>
Message-ID: <Pine.LNX.4.64.0802271226300.5059@axis700.grange>
References: <Pine.LNX.4.64.0802182142240.11540@axis700.grange>
 <20080220063834.GA22708@kroah.com> <Pine.LNX.4.64.0802251341160.4430@axis700.grange>
 <20080226201619.GA10343@kroah.com> <Pine.LNX.4.64.0802271222530.5059@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Guennadi Liakhovetski wrote:

> On Tue, 26 Feb 2008, Greg KH wrote:
> 
> > On Mon, Feb 25, 2008 at 01:43:29PM +0100, Guennadi Liakhovetski wrote:
> > > On Tue, 19 Feb 2008, Greg KH wrote:
> > > 
> > > > On Mon, Feb 18, 2008 at 09:52:25PM +0100, Guennadi Liakhovetski wrote:
> > > > > Booting an x86 SMP PC with todays git-snapshot or just with 2.6.25-rc2 
> > > > > getting the following warnings (with a bit of context):
> > > > 
> > > > Can you try enabling CONFIG_DEBUG_KOBJECT and sending the output at boot
> > > > time from this?
> > > 
> > > dmesg output with CONFIG_LOG_BUF_SHIFT=19 sent privately to Greg as 
> > > unpacked, as it would have to be sent to the list, is 408K big. Will see 
> > > what Greg says.
> > 
> > Thanks for the log, it helped out a lot.  I'm thinking that you have
> > CONFIG_SYSFS_DEPRECATED set to Y, right?  If so, can you set it to N
> > (hopefully you have a new userspace to handle that)?
> 
> Ok, result #1: kernel panic 
> http://home.arcor.de/g.liakhovetski/ap400/imga0045.jpg. If necessary, can 
> try a serial console, but that would be more difficult.

I also put the config at 
http://home.arcor.de/g.liakhovetski/ap400/config-2.6.25-gregkh-0, the 
panic is produced by just disabling CONFIG_SYSFS_DEPRECATED.

Thanks
Guennadi
---
Guennadi Liakhovetski
