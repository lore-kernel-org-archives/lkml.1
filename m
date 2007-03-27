Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbXC0O4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbXC0O4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 10:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbXC0O4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 10:56:07 -0400
Received: from colo.lackof.org ([198.49.126.79]:48504 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbXC0O4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 10:56:06 -0400
Date: Tue, 27 Mar 2007 08:55:52 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, Mitch Williams <mitch.a.williams@intel.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       linux-pci@atrey.karlin.mff.cuni.cz, gregkh@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       auke-jan.h.kok@intel.com
Subject: Re: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table
Message-ID: <20070327145552.GB7157@colo.lackof.org>
References: <1174951102.22190.15.camel@strongmad> <20070327000951.GA11555@kroah.com> <m14po6zupn.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14po6zupn.fsf@ebiederm.dsl.xmission.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2007 at 07:23:16AM -0600, Eric W. Biederman wrote:
> I guess I should add that I'm not certain that the code is exactly correct
> there are weird differences between enable/disable and mask.

My understanding was "enable" would clear (or ignore) pending interrupts
and "unmask" would deliver pending interrupts. Disable and mask could
in many implementations be the same thing as long as the enable/unmask
difference was supported.

thanks,
grnat

>   Where generally
> the mask/unmask methods do the work and enable/disable do some weird software
> thing.  Having them different and enable/disable not doing some software
> thing concerns me a little.  I think mask/unmask may been overoptimized
> in this case.
> 
> So I expect someone will wind up refactor this code at some point.
> 
> However the code is clearly better than what we have now, and it can't
> affect anything else.
> 
> Eric
