Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZAFRdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZAFRdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 12:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbZAFRdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 12:33:07 -0500
Received: from THUNK.ORG ([69.25.196.29]:58621 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbZAFRdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 12:33:04 -0500
Date: Tue, 6 Jan 2009 12:33:00 -0500
From: Theodore Tso <tytso@mit.edu>
To: Jan Beulich <jbeulich@novell.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, ccache@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090106173300.GA10903@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jan Beulich <jbeulich@novell.com>, Sam Ravnborg <sam@ravnborg.org>,
	ccache@lists.samba.org, linux-kernel@vger.kernel.org
References: <E1LKDeQ-0002xz-7E@closure.thunk.org> <496386EF.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496386EF.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 03:29:35PM +0000, Jan Beulich wrote:
> >>> "Theodore Ts'o" <tytso@mit.edu> 06.01.09 16:15 >>>
> >In the short term, though, it would be nice if we could get back a
> >simple way of making a kernel  object file using just cc, so that ccache
> >and distcc could be functional again.   Does that seem reasonable?
> 
> Making the new logic dependent on a config option would seem reasonable
> to me - of course at the expense of the respective Makefile becoming
> even less readable.

Too late.  :-) It's pretty unreadable already.... as a result, I'm not
at all confident that I could make such a patch.  Is this something
you could perhaps whip up?  I'd really appreicate it, as it would
seriously speed up by kernel development efforts.

Regards,

					- Ted
