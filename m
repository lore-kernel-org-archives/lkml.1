Return-Path: <linux-kernel-owner+w=401wt.eu-S1760154AbYBYWDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154AbYBYWDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbYBYWDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:03:40 -0500
Received: from mail.gmx.net ([213.165.64.20]:59289 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750838AbYBYWDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:03:39 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19fhhIULONfLskygXHPSrOHSNhIvyd2euOgWt2q5u
	k8wfJgf0bDMGAA
Date: Mon, 25 Feb 2008 23:03:38 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PCI] duplicate sysfs symbols getting registered in current git
In-Reply-To: <20080225211417.GA20505@kroah.com>
Message-ID: <Pine.LNX.4.64.0802252300250.19416@axis700.grange>
References: <Pine.LNX.4.64.0802182142240.11540@axis700.grange>
 <20080220063834.GA22708@kroah.com> <Pine.LNX.4.64.0802251341160.4430@axis700.grange>
 <Pine.LNX.4.64.0802251913380.19416@axis700.grange> <20080225202546.GA8893@kroah.com>
 <Pine.LNX.4.64.0802252130410.19416@axis700.grange> <20080225211417.GA20505@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008, Greg KH wrote:

> On Mon, Feb 25, 2008 at 09:31:22PM +0100, Guennadi Liakhovetski wrote:
> > On Mon, 25 Feb 2008, Greg KH wrote:
> > 
> > > On Mon, Feb 25, 2008 at 07:15:57PM +0100, Guennadi Liakhovetski wrote:
> > > > On Mon, 25 Feb 2008, Guennadi Liakhovetski wrote:
> > > > 
> > > > > On Tue, 19 Feb 2008, Greg KH wrote:
> > > > > 
> > > > > > On Mon, Feb 18, 2008 at 09:52:25PM +0100, Guennadi Liakhovetski wrote:
> > > > > > > Booting an x86 SMP PC with todays git-snapshot or just with 2.6.25-rc2 
> > > > > > > getting the following warnings (with a bit of context):
> > > > > > 
> > > > > > Can you try enabling CONFIG_DEBUG_KOBJECT and sending the output at boot
> > > > > > time from this?
> > > > > 
> > > > > dmesg output with CONFIG_LOG_BUF_SHIFT=19 sent privately to Greg as 
> > > > > unpacked, as it would have to be sent to the list, is 408K big. Will see 
> > > > > what Greg says.
> > > > 
> > > > Actually, the most annoying problem with post 2.6.24 kernels on this 
> > > > machine is, that the system doesn't power off or reboot any more. And 
> > > > seeing other reports, where the reason for not powering down was unfreed 
> > > > kobjects, maybe this is the problem here too?

[snip]

> Then I suggest filing a new bug report so it doesn't get lost.

Have you found anything interesting in the kobj debugging output? Do you 
think these are two related problems (kobj and failing power-off) or 
separate? So should I file two bug-reports or just one? You mean on 
bugzilla?

Thanks
Guennadi
---
Guennadi Liakhovetski
