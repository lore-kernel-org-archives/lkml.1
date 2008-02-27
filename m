Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbYB0LYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbYB0LYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 06:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbYB0LYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 06:24:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:54389 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752102AbYB0LYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 06:24:46 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19HZ99vi3dHq7JpQ2nQ0/liN4tmkEo8WD0dWFrD8e
	IjZhHcBxVTfvcg
Date: Wed, 27 Feb 2008 12:24:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PCI] duplicate sysfs symbols getting registered in current git
In-Reply-To: <20080226201619.GA10343@kroah.com>
Message-ID: <Pine.LNX.4.64.0802271222530.5059@axis700.grange>
References: <Pine.LNX.4.64.0802182142240.11540@axis700.grange>
 <20080220063834.GA22708@kroah.com> <Pine.LNX.4.64.0802251341160.4430@axis700.grange>
 <20080226201619.GA10343@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Greg KH wrote:

> On Mon, Feb 25, 2008 at 01:43:29PM +0100, Guennadi Liakhovetski wrote:
> > On Tue, 19 Feb 2008, Greg KH wrote:
> > 
> > > On Mon, Feb 18, 2008 at 09:52:25PM +0100, Guennadi Liakhovetski wrote:
> > > > Booting an x86 SMP PC with todays git-snapshot or just with 2.6.25-rc2 
> > > > getting the following warnings (with a bit of context):
> > > 
> > > Can you try enabling CONFIG_DEBUG_KOBJECT and sending the output at boot
> > > time from this?
> > 
> > dmesg output with CONFIG_LOG_BUF_SHIFT=19 sent privately to Greg as 
> > unpacked, as it would have to be sent to the list, is 408K big. Will see 
> > what Greg says.
> 
> Thanks for the log, it helped out a lot.  I'm thinking that you have
> CONFIG_SYSFS_DEPRECATED set to Y, right?  If so, can you set it to N
> (hopefully you have a new userspace to handle that)?

Ok, result #1: kernel panic 
http://home.arcor.de/g.liakhovetski/ap400/imga0045.jpg. If necessary, can 
try a serial console, but that would be more difficult.

Testing further.

Thanks
Guennadi
---
Guennadi Liakhovetski
