Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbYCLQtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbYCLQtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 12:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbYCLQtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 12:49:24 -0400
Received: from styx.suse.cz ([82.119.242.94]:51008 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751685AbYCLQtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 12:49:24 -0400
Date: Wed, 12 Mar 2008 17:49:22 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: David Newall <davidn@davidnewall.com>
cc: Theodore Tso <tytso@mit.edu>, "Fred ." <eldmannen@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Keys get stuck
In-Reply-To: <47D8091E.6030906@davidnewall.com>
Message-ID: <Pine.LNX.4.64.0803121748140.15209@jikos.suse.cz>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com>
 <Pine.LNX.4.64.0803121131200.7266@twin.jikos.cz> <47D7B428.6010804@davidnewall.com>
 <20080312144701.GZ15804@mit.edu> <47D8091E.6030906@davidnewall.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008, David Newall wrote:

> > The problem is that under heavy load the auto-repeat problem is real; 
> > I've seen it as well, and it means that I've started to try to avoid 
> > "make -j4" since that's a great way to trigger it.
> I'm sure it does suck under heavy load, although I suppose you could
> increase the start time.  But I wonder if that is the problem this
> time?  Modern machines are so damned fast they actually take real effort
> to load.  Actually, "make -j4" doesn't sound particularly heavy. 
> There's huge disk i/o in a make.  Plenty of scheduling opportunities. 
> Obviously I only know what everybody else here knows; but with so many
> recent posts suggesting a scheduling fault has been introduced, I'm
> expecting it to be that.

The problem became much more apparent during early -rc phase of 2.6.25 for 
those people that have CONFIG_GROUP_SCHED turned on. This clearly shows 
that X are somehow unhappy with how kernel schedules them, but I don't 
have idea how autorepeat is implemented inside X and what could be the 
problem right now.

-- 
Jiri Kosina
SUSE Labs
