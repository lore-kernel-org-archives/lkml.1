Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbYAHSVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbYAHSVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYAHSVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:21:04 -0500
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:45136 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751643AbYAHSVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:21:03 -0500
Date: Tue, 8 Jan 2008 13:20:48 -0500
From: Theodore Tso <tytso@mit.edu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, apw@shadowen.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Deprecate checkpatch.pl --file
Message-ID: <20080108182048.GM27800@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Daniel Walker <dwalker@mvista.com>, Sam Ravnborg <sam@ravnborg.org>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	apw@shadowen.org, akpm@linux-foundation.org
References: <20080108161403.GA11632@basil.nowhere.org> <1199811033.1756.29.camel@imap.mvista.com> <20080108175347.GA25968@uranus.ravnborg.org> <1199815279.1756.35.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199815279.1756.35.camel@imap.mvista.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 10:01:19AM -0800, Daniel Walker wrote:
> > It is a simple pain/benefit issue.
> > Fixing the 25 errors and 13 warnings in kernel/profile.c may look
> > like an easy task but then we put additional burden on the 10 people
> > that have patches pending for this file.
> 
> This goes for all patches on kernel/profile.c tho .. If I make a big mod
> to kernel/profile.c, that will screw up anyone else who has patches for
> that file..

Obviously, but why make it worse?  And what's more important?  A
"clean tree" (especially when some of the things that checkpatch.pl
flag are arbitrary and Not All That Important), or wasting developers'
time invalidating potentially huge number of patches thanks to cleanup
patches?

							- Ted
