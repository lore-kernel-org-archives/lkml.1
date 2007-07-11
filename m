Return-Path: <linux-kernel-owner+w=401wt.eu-S932359AbXGKLnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbXGKLnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762603AbXGKLnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:43:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49506 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761254AbXGKLnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:43:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Hibernation Redesign
Date: Wed, 11 Jul 2007 13:50:40 +0200
User-Agent: KMail/1.9.5
Cc: a1426z@gawab.com, jeremy@goop.org, jbms@cmu.edu, pavel@ucw.cz,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <200707081737.21932.a1426z@gawab.com> <200707111304.40504.rjw@sisk.pl> <E1I8a6Y-0008Sm-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I8a6Y-0008Sm-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707111350.41806.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 11 July 2007 13:11, Miklos Szeredi wrote:
> > Anyway, to implement the kexec approach we must separate the
> > hibernation from the suspend at the drivers level, which I'm still
> > going to do, but I need to take part in endless discussions
> 
> Discussions are good.  We understand the problem better.  Now I still
> think we don't understand every aspect completely, so continuing the
> discussion makes sense.

OK

I can't do A until I do B, but when I do B, then the entire problem will
change, so what's the point in discussing A before doing B?

> > regarding the freezer, how it is bad and how we should drop it,
> > because it breaks things (which NB is not true, because it doesn't).
> 
> This thread started out from a bug, that seemed to be caused by the
> freezer (we still don't exactly know what it was caused by), and the
> discussion uncovered various problems _with_ the freezer, that up to
> now no other _proper_ solutions have been propsed than to remove the
> freezer.

First, please list those problems for completness.  Moreover, I think they
should be documented if they haven't been yet.

Second, there were many more problems with the freezer in the past and we
were able to eliminate them over time.  It sometimes is difficult to invent a
viable solution on demand ...

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
