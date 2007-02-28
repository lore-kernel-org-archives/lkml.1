Return-Path: <linux-kernel-owner+w=401wt.eu-S1752139AbXB1LIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbXB1LIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 06:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbXB1LIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 06:08:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40641 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbXB1LIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 06:08:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: Problem with freezable workqueues
Date: Wed, 28 Feb 2007 11:59:35 +0100
User-Agent: KMail/1.9.5
Cc: Johannes Berg <johannes@sipsolutions.net>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
References: <200702272251.28844.rjw@sisk.pl> <200702280108.57988.rjw@sisk.pl> <1172625254.8580.37.camel@nigel.suspend2.net>
In-Reply-To: <1172625254.8580.37.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702281159.36079.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 28 February 2007 02:14, Nigel Cunningham wrote:
> Hi.
> 
> On Wed, 2007-02-28 at 01:08 +0100, Rafael J. Wysocki wrote:
> > On Wednesday, 28 February 2007 01:01, Johannes Berg wrote:
> > > On Wed, 2007-02-28 at 00:57 +0100, Rafael J. Wysocki wrote:
> > > 
> > > > Okay, in that case I'd suggest removing create_freezeable_workqueue() and
> > > > make all workqueues nonfreezable once again for 2.6.21 (as far as I know, only
> > > > the two XFS workqueues are affected).
> > > 
> > > I think Nigel might object but I forgot what specific trouble XFS was
> > > causing him.
> > 
> > We suspected that the XFS' worker threads might commit I/O after
> > freeze_processes() has returned, but that hasn't been supported by evidence,
> > as far as I can recall.
> > 
> > Also, making them freezable was controversial ...
> 
> Controversy is no reason to give in! Nevertheless, I think you're right
> - I believe the XFS guys said they fixed the issue that had caused I/O
> to be submitted post-freeze. Well, we'll see if it appears again, won't
> we?

Sure, we will. :-)

Rafael
