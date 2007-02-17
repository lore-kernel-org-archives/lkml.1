Return-Path: <linux-kernel-owner+w=401wt.eu-S1946368AbXBQBwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946368AbXBQBwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 20:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946370AbXBQBwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 20:52:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:56535 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946369AbXBQBwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 20:52:09 -0500
Date: Fri, 16 Feb 2007 17:50:48 -0800
From: Greg KH <greg@kroah.com>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20.git regression: 'PCI: add the sysfs driver name to all modules' causes hard hang on boot
Message-ID: <20070217015048.GB18591@kroah.com>
References: <1171619710.6828.24.camel@Homer.simpson.net> <20070216223609.GA6165@kroah.com> <1171676288.6448.9.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171676288.6448.9.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 02:38:08AM +0100, Mike Galbraith wrote:
> On Fri, 2007-02-16 at 14:36 -0800, Greg KH wrote:
> > On Fri, Feb 16, 2007 at 10:55:10AM +0100, Mike Galbraith wrote:
> > > Greetings,
> > > 
> > > Per $subject, git.yesterday hangs hard on boot here. A git bisect
> > > fingered the commit below, which I verified via git bisect reset; git
> > > revert -n 725522b5453dd680412f2b6463a988e4fd148757, after which box
> > > boots fine.  (well, I hope I verified... i'm git-ignorant)
> > 
> > If you change CONFIG_SYSFS_DEPRECATED to Y, does that solve the problem?
> 
> It's already set.

It's not set in the config file you sent to me and the list :)

thanks,

greg k-h
