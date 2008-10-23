Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbYJWPnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbYJWPnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYJWPmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:42:54 -0400
Received: from kroah.org ([198.145.64.141]:58929 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752563AbYJWPmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:42:53 -0400
Date: Thu, 23 Oct 2008 08:33:48 -0700
From: Greg KH <greg@kroah.com>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Eugene Teo <eteo@redhat.com>, Justin Forbes <jmforbes@linuxtx.org>,
       linux-kernel@vger.kernel.org, Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Willy Tarreau <w@1wt.eu>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Jake Edge <jake@lwn.net>,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>
Subject: Re: [stable] [patch 00/17] 2.6.27-stable review
Message-ID: <20081023153348.GA3995@kroah.com>
References: <20081018183334.GA14035@suse.de> <20081023010126.GB30920@zod.rchland.ibm.com> <20081023045345.GB6949@kroah.com> <20081023063339.11c99044@zod.rchland.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023063339.11c99044@zod.rchland.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 06:33:39AM -0400, Josh Boyer wrote:
> On Wed, 22 Oct 2008 21:53:45 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Wed, Oct 22, 2008 at 09:01:26PM -0400, Josh Boyer wrote:
> > > On Sat, Oct 18, 2008 at 11:33:34AM -0700, Greg KH wrote:
> > > >This is the start of the stable review cycle for the 2.6.27.3 release.
> > > >There are 17 patches in this series, all will be posted as a response
> > > >to this one.  If anyone has any issues with these being applied, please
> > > >let us know.  If anyone is a maintainer of the proper subsystem, and
> > > >wants to add a Signed-off-by: line to the patch, please respond with it.
> > > >
> > > >These patches are sent out with a number of different people on the
> > > >Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
> > > >to add your name to the list.  If you want to be off the reviewer list,
> > > >also email us.
> > > >
> > > >Responses should be made by Wed, October 22, 2008 19:00:00 UTC.
> > > >Anything received after that time might be too late.
> > > 
> > > OK, I realize I'm late.  Apologies in advance for that.
> > > 
> > > I don't see how patches 3, 16, and 17 really fit into the "stable"
> > > rules.  None of them:
> > > 
> > > "... fix a problem that causes a build error (but not for things
> > >  marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
> > >  security issue, or some "oh, that's not good" issue.  In short,
> > >  something critical."
> > > 
> > > So, are we being a bit more lax on the requirements for the
> > > -stable kernels and I missed the memo, or?
> > 
> > Huh?
> > 
> > Patch 3:
> > 	Driver core: Fix cleanup in device_create_vargs().
> > solves a memory leak on an error path that has every opportunity to
> > happen in the driver core.  Do you think this is not a real bug?
> 
> Grr..  Typo on my part.  Patch 4 is the one I originally meant:
> "Driver Core: Clarify device cleanup." It changes nothing but
> comments.  I don't think it's a big deal at all, but are documentation
> changes also allowed now?

It was a documentation change, fixing the information for a core API
call to be correct and match what the code really does.

It also carried no risk of a regression, and as such, I decided to take
it.  If you note, we have also taken other patches that fix up
documentation issues like this in the past, so it was not the first
time.

Was this that big of a deal?

thanks,

greg k-h
