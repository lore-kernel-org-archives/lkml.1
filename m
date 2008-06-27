Return-Path: <linux-kernel-owner+w=401wt.eu-S1761975AbYF0Rfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761975AbYF0Rfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761559AbYF0Rfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:35:30 -0400
Received: from outbound-mail-122.bluehost.com ([67.222.38.22]:56207 "HELO
	outbound-mail-122.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760022AbYF0Rf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:35:28 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: ksummit-2008-discuss@lists.linux-foundation.org
Subject: Re: [Ksummit-2008-discuss] Current List of Kernel Summit suggested topics from the =?iso-8859-1?q?discuss=09list?=
Date: Fri, 27 Jun 2008 10:35:22 -0700
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1214577710.3394.14.camel@localhost.localdomain> <4864FEFB.2050405@linux.intel.com>
In-Reply-To: <4864FEFB.2050405@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806271035.22856.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 27, 2008 7:53 am Arjan van de Ven wrote:
> James Bottomley wrote:
> > Hi All,
> >
> > This is the synopsis of the currently suggested topics so far.  That's
> > not to say this is the list we will be doing, just to say that if
> > there's something you think we should be discussing and it's not on the
> > list, now would be a good time to add it (don't trust the programme
> > committee magically to add it at the last minute ...)
> >
> > James
>
> I'd like to propose a topic about kernel quality; there's been a lot of
> lkml traffic about it (in ups and downs). As part of this topic I could
> present trends, data and conclusions from the kerneloops.org project. I'm
> sure Andrew has a set of data and views from his part of the world, and the
> regressions topic could fall under this too. If we, unlike last year, ask
> various subsystem maintainers to prepare data or at least something more
> solid than "eh I think we're fine" ahead of the conference, we could have a
> more thought out set of inputs from that direction as well.

I think this could be an interesting topic, as long as we have data like what 
you collect at kerneloops.org.  Unfortunately, data for other stuff is harder 
to come by.

Another question this raises is how we define "quality".  Is it simply having 
a low bug count?  Or just having few bugs that affect large numbers of 
people?  Given that we'll always have bugs though, we could also measure 
quality in terms of how effectively we handle bugs, e.g. how quickly fixes 
are proposed and integrated, how well we work with distros to incorporate 
fixes for their high priority issues, etc.

If we measure quality using bug metrics, things are pretty hard.  We have 
kerneloops.org which tracks one class if issues, but there are so few bugs 
filed at kernel.org, relative to other projects that use bug tracking 
heavily, that for PCI at least I could only paint an anecdotal picture of 
things (though we do have one fairly clear area of weakness that I've seen 
based on my triaging).  Contrast this to the Intel graphics projects at 
freedesktop.org where we have a fairly large bug history and can say pretty 
convincingly that things are improving a lot, and fairly rapidly.

I guess I'm saying this *could* be an interesting topic, but it could also be 
the same discussion we've had for years, which never even reaches a 
conclusion about whether we're improving or not.

Jesse
