Return-Path: <linux-kernel-owner+w=401wt.eu-S933084AbYDWBVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084AbYDWBVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 21:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbYDWBU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 21:20:57 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14855 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbYDWBU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 21:20:57 -0400
Date: Tue, 22 Apr 2008 18:19:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Randy Dunlap <RANDY.DUNLAP@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: kgdb: core
Message-Id: <20080422181942.80f96975.randy.dunlap@oracle.com>
In-Reply-To: <480E567B.6060708@windriver.com>
References: <200804181741.m3IHfTeC012089@hera.kernel.org>
	<20080418150930.476ea7aa.akpm@linux-foundation.org>
	<20080421141252.GR9554@elte.hu>
	<20080421214636.617970c6.akpm@linux-foundation.org>
	<20080422082519.62adc7f1.randy.dunlap@oracle.com>
	<20080422135716.c6ee339b.akpm@linux-foundation.org>
	<5739699.1208898133855.JavaMail.oracle@acsmt302.oracle.com>
	<480E567B.6060708@windriver.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2008 16:19:55 -0500 Jason Wessel wrote:

> Randy Dunlap wrote:
> > --- Original Message --- (akpm wrote:)
> >>> On Tue, 22 Apr 2008 08:25:19 -0700 Randy Dunlap
> <randy.dunlap@oracle.com> wrote:
> >>>
> >>> kernel-doc output doesn't depend on build $ARCH.
> >> Ah, interesting.  I made an ass of u and me.
> >>
> >> In that case documentng them in x86 .c and leaving all other definitions
> >> and declarations uncommented sounds the way to go?  
> >
> > Yes, that would be fine and traditional (historical).
> >
> > ~Randy
> >
> 
> So is the summary here that we cannot just document the actual
> interface API in the incude/linux/kgdb.h?

The summary is that we prefer for kernel-doc to be placed at (function
etc.) definition/implementation sites, not at declaration sites.
However, I'm sure that there are exceptions to this.

> The problem I had here was pretty simple in that not all of the
> functions in the API are used by all the archs.  It seemed pretty
> reasonable at the time to just document everything in the .h file
> because it was more for the folks who wanted to add kgdb support to an
> arch and of little to no use to end users of kgdb.

I see.  That could pose a problem.

And there is not any one $arch that does use the complete API?
If so, all of the kernel-doc could be in that $arch.

> The mainline only has a small chunk of the docs right now because not
> all of kgdb is merged.  I was just hoping it was real easy to generate
> some reasonable looking docs.  The docs for all the kgdb code that
> exists (in mainline and not in mainline) can be viewed here as an
> example.
> 
> http://kernel.org/pub/linux/kernel/people/jwessel/kgdb/

If it poses an extreme hardship on you to conform to the
norms/expectations, so be it.  It won't kill anything AFAIK.
(i.e., I won't object.)

---
~Randy
