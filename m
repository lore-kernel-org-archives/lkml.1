Return-Path: <linux-kernel-owner+w=401wt.eu-S934146AbXKPVe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934146AbXKPVe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758597AbXKPVeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:34:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58162 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756625AbXKPVeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:34:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: Suspend/Resume/Hibernation - bisecting or bug-logs?
Date: Fri, 16 Nov 2007 22:38:29 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-kernel@vger.kernel.org
References: <20071116161420.e2c57ff6.Kristoffer.Ericson@Gmail.com> <20071116180006.0029C87EE9C@smtp06.mtu.ru>
In-Reply-To: <20071116180006.0029C87EE9C@smtp06.mtu.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711162238.29709.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 16 of November 2007, Andrey Borzenkov wrote:
> Kristoffer Ericson wrote:
> 
> > Greetings,
> > 
> > Ive been following your discussion and documentation efforts concerning pm
> > in the kernel. This has in the past been a gray area which was hard to
> > find information about so kudos.
> > 
> > I maintain 2 handheld platforms that would benefit greatly from
> > implementing proper pm (mainly suspend) but Im having problems bugtracking
> > it. Currently the system tries to suspend but fails somewhere and then
> > tries to resume (which fails). The end result however is that Im unable to
> > see anything (bugmessages...) since the video driver gets deactivated by
> > pm.
> > 
> > My question is this: Is bisecting (turning off device support in kernel
> > until it works) the best approach when bugtracking pm suspend? Or is there
> > any other logging system that I can use?
> > 
> 
> Good question. I could use advice too :)
> 
> Bisecting is good only if you have known good and known bad versions. From
> your description it sounds like it has never worked - so bisecting won't
> help. Also sometimes bisecting hits way too large commit (this happened to
> me when ACPI replaced mutex with spinlock).

If I understand the original post correctly, Kristoffer didn't mean searching
for a bad patch using bisection. :-)
