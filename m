Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbYAHVVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbYAHVVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757596AbYAHVOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:14:25 -0500
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:46774 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757124AbYAHVOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:14:23 -0500
Date: Tue, 8 Jan 2008 16:14:11 -0500
From: Theodore Tso <tytso@mit.edu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, apw@shadowen.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Deprecate checkpatch.pl --file
Message-ID: <20080108211411.GQ27800@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Daniel Walker <dwalker@mvista.com>, Sam Ravnborg <sam@ravnborg.org>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	apw@shadowen.org, akpm@linux-foundation.org
References: <20080108161403.GA11632@basil.nowhere.org> <1199811033.1756.29.camel@imap.mvista.com> <20080108175347.GA25968@uranus.ravnborg.org> <1199815279.1756.35.camel@imap.mvista.com> <20080108182048.GM27800@mit.edu> <1199817208.1756.47.camel@imap.mvista.com> <20080108192142.GA26491@uranus.ravnborg.org> <1199823584.12972.1.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199823584.12972.1.camel@imap.mvista.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 12:19:44PM -0800, Daniel Walker wrote:
> > But is discourage the creation of pure clean-up patches because it
> > may have a disturbing effect on several other peoples work.
> 
> pure clean ups are _good_ patches , are they not?
> 

Not necessarily.  Whether or not it is requires common sense, and very
often we get enthusiastic new-comers (some of them with very weak C
programming skills :-) who might try to use checkpatch.pl.  So we
can't assume that they will know when a pure clean-up patch is a good
thing, and when it's a waste of everyone's time, including theirs.

That's why I think the warning is a good thing.  It makes it more
likely that this gets communicated to the enthusiastic, well-meaning,
newcomer.  Someone who is more experienced and who knows how to
determine whether some driver is ancient and not being worked on, and
hence a pure clean-up patch won't be screwing up other developers,
will know how to suppress the warning.  (OTOH, how important is it in
the grand scheem of things to create or apply a pure clean-up patch on
a patch that few people if any are looking at?)

					- Ted
