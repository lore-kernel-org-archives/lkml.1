Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab0BDS5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 13:57:42 -0500
Received: from kroah.org ([198.145.64.141]:59502 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757832Ab0BDS5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 13:57:40 -0500
Date: Thu, 4 Feb 2010 10:57:52 -0800
From: Greg KH <greg@kroah.com>
To: Sven Joachim <svenjoac@gmx.de>
Cc: Ben Hutchings <ben@decadent.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       stable-review@kernel.org, stable@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [PATCH] Fix 'flush_old_exec()/setup_new_exec()' split
Message-ID: <20100204185752.GA18595@kroah.com>
References: <1265245849.3362.1.camel@localhost> <1265256174.2952.11.camel@localhost> <alpine.LFD.2.00.1002032135380.3707@localhost.localdomain> <1265272174.2952.20.camel@localhost> <20100204143848.GB15438@kroah.com> <87sk9gbzzt.fsf@turtle.gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sk9gbzzt.fsf@turtle.gmx.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 07:46:30PM +0100, Sven Joachim wrote:
> On 2010-02-04 15:38 +0100, Greg KH wrote:
> 
> > On Thu, Feb 04, 2010 at 08:29:34AM +0000, Ben Hutchings wrote:
> >> On Wed, 2010-02-03 at 21:39 -0800, Linus Torvalds wrote:
> >> > 
> >> > On Thu, 4 Feb 2010, Ben Hutchings wrote:
> >> > > 
> >> > > I'm using Debian i386 (i.e. 32-bit userland) with a 64-bit kernel.
> >> > > After applying commit 221af7f to Debian's kernel source (approximately
> >> > > equivalent to 2.6.32.7), the kernel fails to exec init.  After commit
> >> > > 7ab02af it can exec init but that immediately segfaults:
> >> > 
> >> > It sounds like you have picked individual commits.
> >> 
> >> Yes - I'm one of the kernel package maintainers and we're sticking with
> >> 2.6.32-stable.
> >> 
> >> > But you don't mention commit 05d43ed8a, which is also a required part of 
> >> > the series.
> >> > 
> >> > So you _should_ have a combination of
> >> >  - 221af7f87 ("Split 'flush_old_exec' into two functions")
> >> >  - 05d43ed8a ("x86: get rid of the insane TIF_ABI_PENDING bit")
> >> >  - 7ab02af42 ("Fix 'flush_old_exec()/setup_new_exec()' split")
> >> > 
> >> > (and there are also additional sparc/ppc versions of that TIF_ABI_PENDING 
> >> > bit removal, but they shouldn't matter on your system)
> >> 
> >> Thanks.  If all the necessary patches are all in the stable queue then
> >> we can pick them from there.
> >
> > They should all be there already, if not, please let me know.
> 
> It seems they are all there, but on my system with 64-bit kernel and
> 32-bit userland, 2.6.32.8-rc1 still panics in the way noticed by Ben.

Does 2.6.33-rc6 also cause you the same problem?

thanks,

greg k-h
