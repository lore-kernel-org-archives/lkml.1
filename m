Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZDMXkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZDMXkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 19:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZDMXkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 19:40:01 -0400
Received: from thunk.org ([69.25.196.29]:38274 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbZDMXj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 19:39:59 -0400
Date: Mon, 13 Apr 2009 19:39:53 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH, RFC 0/3] Improvements to the tracing documentation
Message-ID: <20090413233953.GA955@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
	=?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
References: <1239479479-2603-1-git-send-email-tytso@mit.edu> <20090412092524.GA30349@elte.hu> <20090412121533.GB10547@mit.edu> <20090412130105.GB20281@elte.hu> <20090412172344.GC10547@mit.edu> <20090413213124.GB8514@elte.hu> <20090413223526.GB32182@mit.edu> <20090413225542.GJ8514@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413225542.GJ8514@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 12:55:42AM +0200, Ingo Molnar wrote:
> 
> It could be worked around right now by converting it to an integer 
> but i think what we want is native support for kdev_t, together with 
> all the usual convenience forms of specifying it: sda1 should work 
> the same way as 8:1 or 0801. Even /dev/sda1 should be recognized in 
> a filter expression.

Yeah, I could just drop in the integer now, and and just have
TP_printk() display "(8, 2)" instead of "sda2".  It's really a
question of how far we want to take pretty-printing and parsing for
ftrace, I suppose.

But if we are going to have end-users use it, having real
pretty-printed names would be a good thing, IMHO.  Especially if
major/minor numbers start becoming completely random beasts, as some
have proposed.  (I think it's a terrible idea, but I'm clearly not
politically correct.  :-)

						- Ted
