Return-Path: <linux-kernel-owner+w=401wt.eu-S965608AbXCBUxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965608AbXCBUxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 15:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965607AbXCBUxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 15:53:42 -0500
Received: from ns2.suse.de ([195.135.220.15]:50403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965608AbXCBUxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 15:53:41 -0500
Date: Fri, 2 Mar 2007 12:52:40 -0800
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 0/3] Basic msi bug fixes..
Message-ID: <20070302205240.GB24716@kroah.com>
References: <m1tzx7l7z2.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1tzx7l7z2.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 12:24:17PM -0700, Eric W. Biederman wrote:
> 
> While looking at some other irq issues I realized that the current msi code
> has a serious issue in that we don't have support for masking msi interrupts
> on all variations of the msi capabilities.
> 
> Closing that hole is simple, but it requires the msi enable/disable
> logic to be sorted out. Which is a little more complicated...
> 
> These are moderately simples fixes so the should be safe for 2.6.21.

Unless these fix a reported bug, I'd like to hold on to these and wait
for 2.6.22 so they get some testing in a few -mm releases.

thanks,

greg k-h
