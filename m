Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbZGMNnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbZGMNnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 09:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755840AbZGMNnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 09:43:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50026 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829AbZGMNnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 09:43:22 -0400
Subject: Re: inotify regression, missing events
From: Eric Paris <eparis@redhat.com>
To: Scott James Remnant <scott@ubuntu.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1247487669.14981.18.camel@quest>
References: <1247328127.4003.6.camel@wing-commander>
	 <1247313019.2791.1.camel@localhost>  <1247487669.14981.18.camel@quest>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 09:43:19 -0400
Message-Id: <1247492599.3068.19.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-13 at 13:21 +0100, Scott James Remnant wrote:
> On Sat, 2009-07-11 at 07:50 -0400, Eric Paris wrote:
> 
> > On Sat, 2009-07-11 at 17:02 +0100, Scott James Remnant wrote:
> > > Looks like there's a regression with inotify since the rewrite to use
> > > fanotify.  Events are simply missing and not being delivered to
> > > userspace.
> > > 
> > > Here's a simple test case, just compile and run it:
> > 
> > I bet I know exactly what it is (notification.c tail merge code isn't
> > comparing filename only inode+mask) but I'm walking out of the house.
> > I'll try my theory later tonight and post a patch.
> > 
> > Stupid Eric, Stupid.
> > 
> In other words, when the second deleted-file-in-a-directory event comes
> through, it gets ignored because there's already a
> "deleted-file-in-a-directory" event for that directory?

Yes, and I sent a patch but apparent screwed up the --smtp-server option
so it never got out.  Resending.  Sorry.....

-Eric

