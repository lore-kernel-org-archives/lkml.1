Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbXFVWDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbXFVWDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbXFVWDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:03:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59172 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbXFVWDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:03:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Please release a stable kernel Linux 3.0
Date: Sat, 23 Jun 2007 00:10:17 +0200
User-Agent: KMail/1.9.5
Cc: Jesper Juhl <jesper.juhl@gmail.com>,
       =?iso-8859-1?q?Zolt=E1n_HUBERT?= <zoltan.hubert@zzaero.com>,
       linux-kernel@vger.kernel.org
References: <200706212349.54983.zoltan.hubert@zzaero.com> <200706221700.08135.rjw@sisk.pl> <467C02AA.2080105@redhat.com>
In-Reply-To: <467C02AA.2080105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706230010.17772.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 22 June 2007 19:11, Chuck Ebbert wrote:
> On 06/22/2007 11:00 AM, Rafael J. Wysocki wrote:
> > On Friday, 22 June 2007 00:34, Chuck Ebbert wrote:
> >> On 06/21/2007 06:29 PM, Jesper Juhl wrote:
> >>> I myself have argued that we should be focusing more on stability and
> >>> regression fixing, but I'm not so sure that a 2.6.7 devel branch would
> >>> solve this. In general the 2.6.x.y -stable kernels seem to be doing
> >>> the job pretty good.
> >>>
> >>  
> >> Even the good ones that get lots of fixes aren't all that good. The
> >> biggest problem ATM is that suspend is badly broken and keeps getting
> >> worse...
> > 
> > Can you please provide me with any links to suspend-related bug reports from
> > you?
> > 
> 
> I get so many suspend/resume bug reports that I've given up trying
> to get them fixed. And there are so many bugs that are even worse,
> like crashes during normal use, data corruption, etc. that suspend
> bugs don't get much attention. But here are the ones for Fedora 6;
> the list would be much longer if I included Fedora 5 and 7:

Well, thanks.

I'll have a look at these, perhaps I can figure out which patches are needed
to fix them (if there are any).  Also, please add my address to the CC lists
of any new hibernation/suspend-related bug reports, so that I'm aware of them.

FYI, I've started to cherry pick patches related to suspend and hibernation
that I think are relevant for each -rc kernel (at
http://www.sisk.pl/kernel/hibernation_and_suspend/).  [However, I don't
backport patches because of the lack of time, so when the next -rc is out, I
rediff the patchset against this one and don't add new patches for the previous
kernels any more.]

There also is the Hibernation/Suspend subcategory in "Power Management" in
the kernel bugizlla.  Please ask your users to file bug reports in there if
that helps.

Also, all of the currently tracked (with the bugzilla) problems related to
hibernation and suspend are linked to this entry:

http://bugzilla.kernel.org/show_bug.cgi?id=7216

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
