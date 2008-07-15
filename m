Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbYGOWKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbYGOWKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYGOWKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:10:00 -0400
Received: from r00tworld.com ([212.85.137.21]:60152 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbYGOWJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:09:59 -0400
From: pageexec@freemail.hu
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Jul 2008 00:08:55 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Message-ID: <487D3C17.31467.1C3C0441@pageexec.freemail.hu>
In-reply-to: <alpine.LFD.1.10.0807151425170.2867@woody.linux-foundation.org>
References: <20080703185727.GA12617@suse.de>, <487D3056.1183.1C0E1C47@pageexec.freemail.hu>, <alpine.LFD.1.10.0807151425170.2867@woody.linux-foundation.org>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 16 Jul 2008 00:09:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 Jul 2008 at 14:26, Linus Torvalds wrote:

> 
> 
> On Tue, 15 Jul 2008, pageexec@freemail.hu wrote:
> > 
> > and how is that different from today's situation where they aren't told
> > at all?
> 
> Umm. They are. They are told to upgrade to the stable kernel, which 
> should have everything we know about.

you should check out the last few -stable releases then and see how
the announcement doesn't ever mention the word 'security' while fixing
security bugs (see my analysis at http://lwn.net/Articles/288473/).

unless one digs into the actual commits and determines what's going on,
it's easy to make a bad judgement call even for -stable. you know, there
are places that can't just reboot into a new kernel every week for no
reason (Microsoft has patch Tuesday once a month only).

also what about people running older kernels, outside of -stable focus?
do you determine how far back a fix should be applied? i don't think so,
but people maintaining older series will do that, provided they get a hint.

in other words, it's all the more reason to have the commit say it's
fixing a security issue.

> I'm just saying that why mark things, when the marking have no meaning? 
> People who believe in them are just _wrong_.

what is wrong in particular? when you know that you're about to commit a
patch that fixes a security bug, why is it wrong to say so in the commit?
in what way will people reading that commit be misled? they will see it's
fixing a security bug and they can prioritize it for whatever processes they
have for backports, analysis, etc. if they don't see such marks, they will
have to do a whole lot more work (effectively duplicating your own and even
each other's efforts) to figure out the same. why not save them time and
tell them directly what you already know?

cheers,
  PaX Team

