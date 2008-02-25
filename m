Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbYBYUZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbYBYUZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbYBYUZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:25:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43126 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbYBYUZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:25:48 -0500
Date: Mon, 25 Feb 2008 12:25:46 -0800
From: Greg KH <greg@kroah.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PCI] duplicate sysfs symbols getting registered in current git
Message-ID: <20080225202546.GA8893@kroah.com>
References: <Pine.LNX.4.64.0802182142240.11540@axis700.grange> <20080220063834.GA22708@kroah.com> <Pine.LNX.4.64.0802251341160.4430@axis700.grange> <Pine.LNX.4.64.0802251913380.19416@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802251913380.19416@axis700.grange>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 07:15:57PM +0100, Guennadi Liakhovetski wrote:
> On Mon, 25 Feb 2008, Guennadi Liakhovetski wrote:
> 
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
> Actually, the most annoying problem with post 2.6.24 kernels on this 
> machine is, that the system doesn't power off or reboot any more. And 
> seeing other reports, where the reason for not powering down was unfreed 
> kobjects, maybe this is the problem here too?

If you have cpufreq enabled, that should solve this problem after the
2.6.24-rc3 kernel release.  Have you tried that version?

thanks,

greg k-h
