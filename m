Return-Path: <linux-kernel-owner+w=401wt.eu-S939365AbZDJR7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939365AbZDJR7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764846AbZDJR65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:58:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45239 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759932AbZDJR64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:58:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: suspend-to-ram broken on X61 thinkpads in 2.6.30-rc1?
Date: Fri, 10 Apr 2009 19:58:45 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc1-rjw; KDE/4.2.2; x86_64; ; )
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
References: <E1Ls9pZ-0004IF-FZ@closure.thunk.org> <200904101448.38166.rjw@sisk.pl> <b6a2187b0904100600j261c4ea4l5e0f87a9fe0fe22c@mail.gmail.com>
In-Reply-To: <b6a2187b0904100600j261c4ea4l5e0f87a9fe0fe22c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904101958.46245.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 April 2009, Jeff Chua wrote:
> 2009/4/10 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Friday 10 April 2009, Theodore Ts'o wrote:
> >> Hi, has anyone else noticed that suspend-to-ram seems to have gotten
> >> broken in 2.6.30-rc1, sometime during last half of the merge window?
> 
> My X61 STR is broken as well.
> 
> > There was one similar report, but that issue should be fixed in 2.6.30-rc1
> > if I remember correctly.
> >
> > Can you test commit 0a0c5168df270a50e3518e4f12bddb31f8f5f38f
> > (PM: Introduce functions for suspending and resuming device interrupts), plaese?
> 
> This commit is in the latest git, but it's does not seem to fix the
> problem. 2.6.29 STR works very well. And all the Think "Fn" keys are
> no longer working (LID close still functioning though ... but that
> could a configuration issue moving from 2.6.29 to 2.6.30-rc1.

I meant please test the kernel where commit
0a0c5168df270a50e3518e4f12bddb31f8f5f38f is the head.  It is possible that one
of the commits immediately following it broke things.  If that's the case, this
kernel will work for you.
 
> Shall I do the bisecting? I think this is the only one not working for
> me other than the slow iptables that I reported earlier.

Please first do the test above.

Thanks,
Rafael
