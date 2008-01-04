Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbYADWrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbYADWrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 17:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbYADWq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 17:46:59 -0500
Received: from mail.fieldses.org ([66.93.2.214]:47279 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840AbYADWq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 17:46:58 -0500
Date: Fri, 4 Jan 2008 17:46:41 -0500
To: Andi Kleen <ak@suse.de>
Cc: Joe Perches <joe@perches.com>, Sam Ravnborg <sam@ravnborg.org>,
       Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH x86] [5/16] Replace hard coded reservations in x86-64
	early boot code with dynamic table II
Message-ID: <20080104224641.GE14827@fieldses.org>
References: <20080103442.621670000@suse.de> <20080104180650.GA2998@bingen.suse.de> <1199472453.4888.19.camel@localhost> <200801042313.14551.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801042313.14551.ak@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 11:13:14PM +0100, Andi Kleen wrote:
> On Friday 04 January 2008 19:47:33 Joe Perches wrote:
> > On Fri, 2008-01-04 at 19:06 +0100, Andi Kleen wrote:
> > > But the problem with your "rule" is that every of the hundreds
> > > of Linux kernel contributors will need to do the same. And that's just 
> > > ineffecient, waste of valuable human work and just doesn't make much sense.
> > > 
> > > It certainly won't improve Linux in any way.
> > 
> > What I would prefer is a git option that supports
> > check-in/outs in a coding style of a user choice.
> 
> I'm not very deep into git specifics, but for the spaces<->tab problem
> I suspect some kind of commit hook script would be the correct solution.
> i.e. always convert them in newly changed lines as comitted.

If you've got the very latest git, after

	cd linux-2.6/
	echo "* whitespace" >.gitattributes

it'll treat any spaces in initial whitespace that could have been tabs
as bad whitespace, for the purposes of commands like git-am.  (So e.g.

	git-am --whitespace=fix mbox

will rewrite such stuff with tabs.)  For details search for whitespace
in the gitattributes, git-config, and git-apply man pages....

--b.
