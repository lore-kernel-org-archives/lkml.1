Return-Path: <linux-kernel-owner+w=401wt.eu-S932972AbYD3XD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972AbYD3XD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757270AbYD3XDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:03:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47114 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794AbYD3XDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:03:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Slow DOWN, please!!!
Date: Thu, 1 May 2008 01:03:06 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, Greg KH <greg@kroah.com>
References: <20080429.190352.137408408.davem@davemloft.net> <200805010023.32213.rjw@sisk.pl> <alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805010103.07275.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 1 of May 2008, Linus Torvalds wrote:
> 
> On Thu, 1 May 2008, Rafael J. Wysocki wrote:
> > 
> > > And there's no way to avoid the fact that during the merge window, we will 
> > > get something on the order of ten thousand commits (eg 2.6.24->25-rc1 was 
> > > 9629 commits).
> > 
> > Well, do we _have_ _to_ take that much?  I know we _can_, but is this really
> > necessary?
> 
> Do you want me to stop merging your code?

Well, no, but actually there are only a few of my patches in this merge
window. :-)

Moreover, if the maintainers who took them told me they would be scheduled for
the next merge window, I wouldn't mind.  That actually happended to some of my
patches that are in the Greg's tree at the moment and that's fine (although I
consider the patches as important).

IMO, this is a question of balance.  Of course, a maintainer can take
everything from everyone, but at the same time he can have a look at the
patches and say "Well, I have lots of stuff scheduled for this merge window
already, this stuff of yours will wait for the next merge window.  Please
improve the code or review the others' patches in the meantime".  The only
thing is to give everyone a fair treatment, which may be a challenge.

> Do you think anybody else does?

I think the majority of developers would understand if you told them you could
only merge a limited amount of changes in a single merge window, provided that
they would be treated fairly.

When you take everything from everyone, you actually reward people who are
able to develop more code between merge windows.  Not necessarily those who
spend time on different important activities, such as reviewing the others'
code, bug tracking etc.

> Any suggestions on how to convince people that their code is not worth 
> merging?

That shouldn't be necessary. :-)

The point is to tell people to develop the code less rapidly, so to speak.
Or maybe more carefully.

Thanks,
Rafael
