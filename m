Return-Path: <linux-kernel-owner+w=401wt.eu-S1759739AbXJLLWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739AbXJLLWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 07:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757299AbXJLLWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 07:22:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47643 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbXJLLWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 07:22:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 0/2 -mm] kexec based hibernation -v5
Date: Fri, 12 Oct 2007 13:37:17 +0200
User-Agent: KMail/1.9.5
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1192068833.27482.13.camel@caritas-dev.intel.com> <200710111217.58473.rjw@sisk.pl> <1192159172.17539.26.camel@caritas-dev.intel.com>
In-Reply-To: <1192159172.17539.26.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710121337.18499.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 12 October 2007 05:19, Huang, Ying wrote:
> On Thu, 2007-10-11 at 12:17 +0200, Rafael J. Wysocki wrote:
> > On Thursday, 11 October 2007 04:13, Huang, Ying wrote:
> > > Kexec base hibernation has some potential advantages over uswsusp and
> > > TuxOnIce (suspend2). Some most obvious advantages are:
> > 
> > Well, I have some doubts as far as the obviousness is concerned.
> 
> OK, I will remove the "obvious".
> 
> > > 1. The hibernation image size can exceed half of memory size easily.
> > 
> > This is also possible with TuxOnIce.
> 
> I will add detail description about this. It is possible with TuxOnIce,
> and hard with u/swsusp.

Actually, possible with TuxOnIce, impossible with u/swsusp, at present.
 
> > > 2. The hibernation image can be written to and read from almost
> > >    anywhere, such as USB disk, NFS.
> > 
> > This is possible with uswsusp, at least in theory, probably with TuxOnIce too.
> 
> I will remove this.

OK, thanks.
 
> > > 3. It is possible to eliminate freezer from kexec based hibernation
> > >    implementation.
> > 
> > This isn't true as long as we have not changed the handling of devices
> > (which is in the works, but will take time).
> 
> I know it has not been implemented yet. I just say that it is possible
> for khibernation and it is almost impossible for u/swsusp and TuxOnIce.

When that's implemented, it may be possible to avoid using the freezer for
u/swsusp and TuxOnIce either.  Time will tell.

Greetings,
Rafael
