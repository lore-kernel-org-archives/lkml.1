Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbXD1TKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbXD1TKu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbXD1TKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:10:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34502 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784AbXD1TKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:10:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Lang <david.lang@digitalinsight.com>
Subject: Re: Back to the future.
Date: Sat, 28 Apr 2007 21:14:48 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <20070428085000.GA3293@elf.ucw.cz> <Pine.LNX.4.63.0704281130200.11638@qynat.qvtvafvgr.pbz>
In-Reply-To: <Pine.LNX.4.63.0704281130200.11638@qynat.qvtvafvgr.pbz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704282114.49815.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 28 April 2007 20:32, David Lang wrote:
> On Sat, 28 Apr 2007, Pavel Machek wrote:
> 
> >>
> >> We freeze user space processes for the reasons that you have quoted above.
> >>
> >> Why we freeze kernel threads in there too is a good question, but not for me to
> >> answer.  I don't know.  Pavel should know, I think.
> >
> > We do not want kernel threads running:
> >
> > a) they may hold some locks and deadlock suspend
> >
> > b) they may do some writes to disk, leading to corruption
> >
> > We could solve a) by carefully auditing suspend lock usage to make
> > sure deadlocks are impossible even with kernel threads running.
> 
> remember that we are doing suspend-to-disk, after we do the snapshot we will be 
> doing a shutdown. that should simplify the locking issues

That's assuming that we won't need to cancel the hibernation.

Greetings,
Rafael
