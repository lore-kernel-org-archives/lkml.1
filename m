Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZJ0E4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZJ0E4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 00:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbZJ0E4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 00:56:39 -0400
Received: from THUNK.ORG ([69.25.196.29]:53372 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394AbZJ0E4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 00:56:38 -0400
Date: Tue, 27 Oct 2009 00:56:32 -0400
From: Theodore Tso <tytso@mit.edu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Miller <davem@davemloft.net>, sam@ravnborg.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, nico@fluxnic.net, tony.luck@intel.com,
       sfr@canb.auug.org.au, mcgrof@gmail.com, jeff@garzik.org,
       robert.richter@amd.com, dmitry.torokhov@gmail.com, khali@linux-fr.org,
       torvalds@linux-foundation.org
Subject: Re: [RFC] to rebase or not to rebase on linux-next
Message-ID: <20091027045632.GK13941@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Steven Rostedt <rostedt@goodmis.org>,
	David Miller <davem@davemloft.net>, sam@ravnborg.org, mingo@elte.hu,
	linux-kernel@vger.kernel.org, nico@fluxnic.net, tony.luck@intel.com,
	sfr@canb.auug.org.au, mcgrof@gmail.com, jeff@garzik.org,
	robert.richter@amd.com, dmitry.torokhov@gmail.com,
	khali@linux-fr.org, torvalds@linux-foundation.org
References: <1256601061.26028.350.camel@gandalf.stny.rr.com> <20091026.171539.06989895.davem@davemloft.net> <1256603403.26028.358.camel@gandalf.stny.rr.com> <20091026.183416.52095233.davem@davemloft.net> <1256612558.26028.391.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256612558.26028.391.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 11:02:38PM -0400, Steven Rostedt wrote:
> > The problem isn't that you have to push patches out and only work
> > with patches, the problem is that you want to use publicly visible
> > GIT trees to do your testing at all times.
> > 
> > And sorry, that is not how you're supposed to do things.
> 
> That is a matter of opinion. We prefer to keep things as public as
> possible. No patches back and forth privately doing our own internal
> test suites, then come out with some "production release". If someone
> found something wrong with it then, we would need to start the cycle all
> over again.

There's nothing wrong with public branches that happen to be regularly
rewound, and they do exist in nature.  Exhibit one: The 'pu' branch in
git.  Exihibit two: linux-next.

It's strange to see people arguing for non-transparency, just because
we happen to be using git.  Given that linux-mm uses quilt, and
linux-next accepts quilt patches, I really don't see anything wrong
with linux-next taking git branches that are occasionally rewound when
doing things like adding tested-by:, or when I want to clarify or
rewrite rewrite the patch commit description or even in-code comments
into proper English.

Maybe we need better ways of advertising that a particular branch is
unstable, so people can be adequately warned they base work on that
branch at their own risk.  But fundamentally, saying that we should
keep git branches sekrit just because they might be rewound doesn't
seem to make sense.

							- Ted
