Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZFYP5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZFYP5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZFYP5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:57:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:33585 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbZFYP5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:57:12 -0400
Date: Thu, 25 Jun 2009 08:30:35 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       paul@pwsan.com, stern@rowland.harvard.edu,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] Driver Core: Add platform device arch data V3
Message-ID: <20090625153035.GA21920@suse.de>
References: <20090610121659.27937.13560.sendpatchset@rx1.opensource.se> <87r5xhqzr4.fsf@deeprootsystems.com> <200906251635.44787.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906251635.44787.rjw@sisk.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 04:35:43PM +0200, Rafael J. Wysocki wrote:
> On Thursday 18 June 2009, Kevin Hilman wrote:
> > Magnus Damm <magnus.damm@gmail.com> writes:
> > 
> > > From: Magnus Damm <damm@igel.co.jp>
> > >
> > > Allow architecture specific data in struct platform_device V3.
> > >
> > > With this patch struct pdev_archdata is added to struct
> > > platform_device, similar to struct dev_archdata in found in
> > > struct device. Useful for architecture code that needs to
> > > keep extra data associated with each platform device.
> > >
> > > Struct pdev_archdata is different from dev.platform_data, the
> > > convention is that dev.platform_data points to driver-specific
> > > data. It may or may not be required by the driver. The format
> > > of this depends on driver but is the same across architectures.
> > >
> > > The structure pdev_archdata is a place for architecture specific
> > > data. This data is handled by architecture specific code (for
> > > example runtime PM), and since it is architecture specific it
> > > should _never_ be touched by device driver code. Exactly like
> > > struct dev_archdata but for platform devices.
> > >
> > > Signed-off-by: Magnus Damm <damm@igel.co.jp>
> > 
> > Since there is no 'Feature-desired-by:' tag, I'll addd
> > 
> > Acked-by: Kevin Hilman <khilman@deeprootsystems.com>
> > 
> > For PM on ARM in general, and OMAP in particular we definitely need a
> > generic way to handle arch-specific data per platform_device.
> 
> Greg, is this patch fine with you?

Yes:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
