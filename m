Return-Path: <linux-kernel-owner+w=401wt.eu-S1161130AbXCVWKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161130AbXCVWKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 18:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161140AbXCVWKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 18:10:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:34490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161130AbXCVWKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 18:10:34 -0400
Date: Thu, 22 Mar 2007 15:08:37 -0700
From: Greg KH <greg@kroah.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, daniel.e.wolstenholme@intel.com
Subject: Re: [PATCH 0/21] MSI rework
Message-ID: <20070322220837.GD20713@kroah.com>
References: <1174560686.307511.956605711793.qpush@cradle> <m1lkhp8gqx.fsf@ebiederm.dsl.xmission.com> <20070322190834.GA14802@kroah.com> <1174600936.10836.53.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174600936.10836.53.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 09:02:16AM +1100, Benjamin Herrenschmidt wrote:
> > > i.e.  First the simple bug fixes that should purely be restructure of
> > > msi.c with no affect on anything outside of it.
> > > 
> > > And then get into the architecture enhancements.
> > 
> > I agree, care to break these down into a smaller series of patches that
> > can go into -mm for testing?
> 
> I don't see the point in breaking the serie... you can bisect half way
> through if necessary... it's made of small patches that are done, afaik,
> in such a way that the whole thing should still work at any level in the
> serie.
> 
> The serie just expresses the dependency between them.

Ok, then which patches in the series should be acceptable to take right
now for 2.6.22?  The "clean up the BUG" ones?

thanks,

greg k-h
