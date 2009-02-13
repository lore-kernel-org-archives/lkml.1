Return-Path: <linux-kernel-owner+w=401wt.eu-S1760816AbZBMDcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816AbZBMDcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 22:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756983AbZBMDcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 22:32:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:60371 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545AbZBMDcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 22:32:41 -0500
Date: Thu, 12 Feb 2009 19:29:58 -0800
From: Greg KH <gregkh@suse.de>
To: David Engel <david@istwok.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.27.16
Message-ID: <20090213032958.GA4474@suse.de>
References: <20090212180448.GC15341@kroah.com> <20090212180505.GD15341@kroah.com> <20090212180448.GC15341@kroah.com> <20090212230100.GA31159@opus.istwok.net> <20090213010827.GA8562@suse.de> <20090213011404.GB8562@suse.de> <20090213012955.GA14366@suse.de> <20090213032550.GB3721@opus.istwok.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213032550.GB3721@opus.istwok.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 09:25:50PM -0600, David Engel wrote:
> On Thu, Feb 12, 2009 at 05:29:55PM -0800, Greg KH wrote:
> > On Thu, Feb 12, 2009 at 05:14:04PM -0800, Greg KH wrote:
> > > On Thu, Feb 12, 2009 at 05:08:27PM -0800, Greg KH wrote:
> > > > > It seems that dev->platform_data is NULL on my system.
> > > > 
> > > > Not good, let me dig to see if I missed a patch...
> > > 
> > > Ok, I did.
> > > 
> > > If you apply the patch below, does the oops go away?
> 
> 3 or 4 chunks failed to apply and the ones that did apply were offset
> by several lines.  If you'd like, I can try to apply it by hand and
> test it tomorrow.

No, I thought better of it after looking at the code :)

> > > But that's not really a "stable" fix, so I guess I'll just go revert the
> > > problem patch.  Let me go make that fix...
> > 
> > Ok, I reverted the problem patch and released 2.6.27.17.  Please let me
> > know if you still have a problem with that kernel release.
> 
> I'm building 2.6.27.17 now, but I expect it to work since reverting
> that one patch is all I did to get 2.6.27.16 working for me.

Yeah, that's what I'm more concerned about.

thanks,

greg k-h
