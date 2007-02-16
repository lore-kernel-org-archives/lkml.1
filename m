Return-Path: <linux-kernel-owner+w=401wt.eu-S1946150AbXBPWh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946150AbXBPWh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 17:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946263AbXBPWh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 17:37:28 -0500
Received: from ns1.suse.de ([195.135.220.2]:36937 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946150AbXBPWh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 17:37:27 -0500
Date: Fri, 16 Feb 2007 14:36:09 -0800
From: Greg KH <greg@kroah.com>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20.git regression: 'PCI: add the sysfs driver name to all modules' causes hard hang on boot
Message-ID: <20070216223609.GA6165@kroah.com>
References: <1171619710.6828.24.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171619710.6828.24.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 10:55:10AM +0100, Mike Galbraith wrote:
> Greetings,
> 
> Per $subject, git.yesterday hangs hard on boot here. A git bisect
> fingered the commit below, which I verified via git bisect reset; git
> revert -n 725522b5453dd680412f2b6463a988e4fd148757, after which box
> boots fine.  (well, I hope I verified... i'm git-ignorant)

If you change CONFIG_SYSFS_DEPRECATED to Y, does that solve the problem?

If not, can you press alt-sysrq-T and send us the list of the tasks so
that we can try to figure out what is hanging here?

thanks,

greg k-h
