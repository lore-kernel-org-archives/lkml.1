Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbXH0Prv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbXH0Prv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 11:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbXH0Prn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:47:43 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:21101 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbXH0Prm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:47:42 -0400
Subject: Re: Who wants to maintain KR list for stable releases? (was Re:
	nmi_watchdog=2 regression in 2.6.21)
From: Daniel Walker <dwalker@mvista.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       Natalie Protasevich <protasnb@gmail.com>
In-Reply-To: <6bffcb0e0708270826p7a7fb044re53d0db4094bc3d5@mail.gmail.com>
References: <1186531609.22044.50.camel@imap.mvista.com>
	 <20070808142059.GF30805@atjola.homenet>
	 <1187628296.7732.14.camel@imap.mvista.com>
	 <46CDE94A.7000600@googlemail.com>
	 <1187904169.2435.83.camel@dhcp193.mvista.com>
	 <46D21E8E.4000003@googlemail.com>
	 <20070827005131.b93f5935.akpm@linux-foundation.org>
	 <6bffcb0e0708270438j4c92a0b4m1396b4010f25bfb5@mail.gmail.com>
	 <1188227585.2435.192.camel@dhcp193.mvista.com>
	 <6bffcb0e0708270826p7a7fb044re53d0db4094bc3d5@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 08:39:57 -0700
Message-Id: <1188229197.2435.207.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 17:26 +0200, Michal Piotrowski wrote:
> On 27/08/07, Daniel Walker <dwalker@mvista.com> wrote:
> > On Mon, 2007-08-27 at 13:38 +0200, Michal Piotrowski wrote:
> > > On 27/08/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> [..]
> > > > I'm not sure that we need one, really.  Any bugs in a stable release can be
> > > > handled via email and/or bugzilla as we are presently doing?
> > > >
> > > > What I'm concerned about is that regressions which we didn't fix are just
> > > > getting lost.  Is anyone taking care to ensure that they are getting
> > > > transitioned into bugzilla for tracking?
> > >
> > > I can copy all regression reports into Bugzilla after each release.
> >
> > Should we get the regression field fix before? Or had you planned on
> > just bypassing that completely ?
> 
> IMO solution proposed by David http://lkml.org/lkml/2007/8/27/21 seems
> to be most reasonable.

Now that I'm looking at the kernel bugzilla .. If you set the kernel
version to 2.6.22 and set the "Regression" check box you could denote
the fact that it's a regression in that kernel version ..

I don't know if this URL is going to come out right,

http://bugzilla.kernel.org/buglist.cgi?query_format=advanced&short_desc_type=allwordssubstr&short_desc=&tree=Mainline&long_desc_type=substring&long_desc=&kernel_version_type=allwordssubstr&kernel_version=2.6.22&bug_status=NEW&bug_status=REOPENED&bug_status=ASSIGNED&emailassigned_to1=1&emailtype1=substring&email1=&emailassigned_to2=1&emailreporter2=1&emailcc2=1&emailtype2=substring&email2=&bugidtype=include&bug_id=&chfieldfrom=&chfieldto=Now&chfieldvalue=&regression=include&cmdtype=doit&order=Reuse+same+sort+as+last+time&field0-0-0=noop&type0-0-0=noop&value0-0-0=

That should be open bugs , kernel version 2.6.22, with the regression
check box set ..

So you may not need a master tracking bug ..

Daniel



