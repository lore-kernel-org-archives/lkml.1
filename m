Return-Path: <linux-kernel-owner+w=401wt.eu-S965261AbXCVTKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965261AbXCVTKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965337AbXCVTKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:10:42 -0400
Received: from ns2.suse.de ([195.135.220.15]:52852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965261AbXCVTKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:10:41 -0400
Date: Thu, 22 Mar 2007 12:08:34 -0700
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michael Ellerman <michael@ellerman.id.au>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       daniel.e.wolstenholme@intel.com
Subject: Re: [PATCH 0/21] MSI rework
Message-ID: <20070322190834.GA14802@kroah.com>
References: <1174560686.307511.956605711793.qpush@cradle> <m1lkhp8gqx.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1lkhp8gqx.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 09:01:10AM -0600, Eric W. Biederman wrote:
> Michael Ellerman <michael@ellerman.id.au> writes:
> 
> > This is my series to rework the generic MSI code into something we can use
> > on powerpc[1].
> >
> > I've tried as much as possible not to change the semantics for other archs,
> > but there's a few little changes. I think they're all OK in their own right.
> >
> > I don't have any serious hardware to test on, but my little x86_64 box with
> > an e1000 using MSI still works with these changes. I've also got MSI working
> > on a powerpc blade with a tg3. I haven't tested MSI-X _at all_.
> >
> > I've also tested on the blade with a debug hack to make the MSI case
> > allocate/free 8 MSIs, but only use the last one, just to exercise the n > 1
> > case a little. All seems to work fine.
> 
> Generally I think this looks good.  However there is a lot here, and some
> of it potentially at least has some pretty subtle side effects.
> 
> So reviewing all of these patches at once is almost certain to cause
> something important to be missed :(
> 
> Can we slow this process down a few days by taking this one logical chunk
> at a time?
> 
> i.e.  First the simple bug fixes that should purely be restructure of
> msi.c with no affect on anything outside of it.
> 
> And then get into the architecture enhancements.

I agree, care to break these down into a smaller series of patches that
can go into -mm for testing?

thanks,

greg k-h
