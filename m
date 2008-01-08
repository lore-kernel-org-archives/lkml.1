Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbYAHVwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbYAHVwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYAHVwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:52:22 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:19305 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbYAHVwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:52:21 -0500
Subject: Re: [PATCH] Deprecate checkpatch.pl --file
From: Daniel Walker <dwalker@mvista.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, apw@shadowen.org,
       akpm@linux-foundation.org
In-Reply-To: <20080108211411.GQ27800@mit.edu>
References: <20080108161403.GA11632@basil.nowhere.org>
	 <1199811033.1756.29.camel@imap.mvista.com>
	 <20080108175347.GA25968@uranus.ravnborg.org>
	 <1199815279.1756.35.camel@imap.mvista.com> <20080108182048.GM27800@mit.edu>
	 <1199817208.1756.47.camel@imap.mvista.com>
	 <20080108192142.GA26491@uranus.ravnborg.org>
	 <1199823584.12972.1.camel@imap.mvista.com> <20080108211411.GQ27800@mit.edu>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 13:50:59 -0800
Message-Id: <1199829059.12972.40.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-08 at 16:14 -0500, Theodore Tso wrote:
> On Tue, Jan 08, 2008 at 12:19:44PM -0800, Daniel Walker wrote:
> > > But is discourage the creation of pure clean-up patches because it
> > > may have a disturbing effect on several other peoples work.
> > 
> > pure clean ups are _good_ patches , are they not?
> > 
> 
> Not necessarily.  Whether or not it is requires common sense, and very
> often we get enthusiastic new-comers (some of them with very weak C
> programming skills :-) who might try to use checkpatch.pl.  So we
> can't assume that they will know when a pure clean-up patch is a good
> thing, and when it's a waste of everyone's time, including theirs.

You can pretty much generalize this to many patches on many mailing
lists.. Someone submits a patch that they didn't think about, and ..
It's at least a learning experience for the person submitting the patch.
It does however seem a lot less likely someone will screw up a change
when checkpatch.pl actually tells you the line where the style problem
is, and what it is .. Even with "WARNING" and "ERROR" classifications.

> That's why I think the warning is a good thing.  It makes it more
> likely that this gets communicated to the enthusiastic, well-meaning,
> newcomer.  Someone who is more experienced and who knows how to
> determine whether some driver is ancient and not being worked on, and
> hence a pure clean-up patch won't be screwing up other developers,
> will know how to suppress the warning.  (OTOH, how important is it in
> the grand scheem of things to create or apply a pure clean-up patch on
> a patch that few people if any are looking at?)

There is a maintainer involved in all this .. The maintainer needs to
accept the patch prior to it "... screwing up other developers." Given a
sane maintainer, and a sane list review then why wouldn't a pure clean
up be accepted?

The warning message is actually an end run around the maintainer.. The
clean up never gets created, and the maintainer doesn't have the choice
to include it or not.. 

Daniel

