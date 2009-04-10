Return-Path: <linux-kernel-owner+w=401wt.eu-S938450AbZDJRQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938450AbZDJRQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936944AbZDJRPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:15:43 -0400
Received: from THUNK.ORG ([69.25.196.29]:44980 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937220AbZDJRPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:15:41 -0400
Date: Fri, 10 Apr 2009 12:48:08 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: suspend-to-ram broken on X61 thinkpads in 2.6.30-rc1?
Message-ID: <20090410164808.GA8491@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jeff Chua <jeff.chua.linux@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
References: <E1Ls9pZ-0004IF-FZ@closure.thunk.org> <200904101448.38166.rjw@sisk.pl> <b6a2187b0904100600j261c4ea4l5e0f87a9fe0fe22c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0904100600j261c4ea4l5e0f87a9fe0fe22c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 09:00:08PM +0800, Jeff Chua wrote:
> 2009/4/10 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Friday 10 April 2009, Theodore Ts'o wrote:
> >> Hi, has anyone else noticed that suspend-to-ram seems to have gotten
> >> broken in 2.6.30-rc1, sometime during last half of the merge window?
> 
> My X61 STR is broken as well.
> 
> This commit is in the latest git, but it's does not seem to fix the
> problem. 2.6.29 STR works very well. And all the Think "Fn" keys are
> no longer working (LID close still functioning though ... but that
> could a configuration issue moving from 2.6.29 to 2.6.30-rc1.

I'm seeing this problem as well.

> Shall I do the bisecting? I think this is the only one not working for
> me other than the slow iptables that I reported earlier.

Well, I can save you at least one or two reboots, based on some
test kernels I had been building.

git bisect bad v2.6.30-rc1-git2
git bisect bad v2.6.30-rc1	
git bisect bad e0724bf6		(v2.6.29-git14 circa April 6th)
git bisect good 5d80f8e5	(v2.6.29-git3 circa March 27th)

Only 3,074 revisions to go.  :-)

          					- Ted


