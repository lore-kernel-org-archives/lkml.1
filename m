Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYAHSe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYAHSe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbYAHSet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:34:49 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:39754 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbYAHSes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:34:48 -0500
Subject: Re: [PATCH] Deprecate checkpatch.pl --file
From: Daniel Walker <dwalker@mvista.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, apw@shadowen.org,
       akpm@linux-foundation.org
In-Reply-To: <20080108182048.GM27800@mit.edu>
References: <20080108161403.GA11632@basil.nowhere.org>
	 <1199811033.1756.29.camel@imap.mvista.com>
	 <20080108175347.GA25968@uranus.ravnborg.org>
	 <1199815279.1756.35.camel@imap.mvista.com> <20080108182048.GM27800@mit.edu>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 10:33:28 -0800
Message-Id: <1199817208.1756.47.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-08 at 13:20 -0500, Theodore Tso wrote:
> On Tue, Jan 08, 2008 at 10:01:19AM -0800, Daniel Walker wrote:
> > > It is a simple pain/benefit issue.
> > > Fixing the 25 errors and 13 warnings in kernel/profile.c may look
> > > like an easy task but then we put additional burden on the 10 people
> > > that have patches pending for this file.
> > 
> > This goes for all patches on kernel/profile.c tho .. If I make a big mod
> > to kernel/profile.c, that will screw up anyone else who has patches for
> > that file..
> 
> Obviously, but why make it worse?  And what's more important?  A
> "clean tree" (especially when some of the things that checkpatch.pl
> flag are arbitrary and Not All That Important), or wasting developers'
> time invalidating potentially huge number of patches thanks to cleanup
> patches?

What I was saying in my first email was we can throttle "patches"
arbitrarily (I think Andrew/Linus even have a merge period for these
types of patches) ..  So that's not the issue .. I feel style clean ups
are fundamentally good.. So what we don't want to do is discourage the
creation of good patches, which is what I think Andi is doing..

If there's something in checkpatch.pl that you think is "Not All That
Important", than send a patch to remove those cases and we can discuss
that directly.. I'm not saying the tool is perfect..

Daniel

