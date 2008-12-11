Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbYLKI7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbYLKI7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 03:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbYLKI71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 03:59:27 -0500
Received: from phunq.net ([64.81.85.152]:45127 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754116AbYLKI70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 03:59:26 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Tux3 report: Tux3 by Christmas?
Date: Thu, 11 Dec 2008 00:59:24 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tux3@tux3.org
References: <200812101435.40393.phillips@phunq.net> <20081210233617.ddb3fa30.akpm@linux-foundation.org>
In-Reply-To: <20081210233617.ddb3fa30.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812110059.25155.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 December 2008 23:36, Andrew Morton wrote:
> On Wed, 10 Dec 2008 14:35:39 -0800 Daniel Phillips <phillips@phunq.net> wrote:
> 
> > The big goals for Christmas (this Christmas!) are:
> > 
> >    - SMP locking
> >    - Atomic commit
> >    - Posixly complete
> >    - Rudimentary fsck
> > 
> > ...
> > 
> > Non-goals for Christmas include:
> > 
> >    - Versioning
> >    - Directory indexing (PHTree)
> >    - fsck repair
> 
> If it is your intention to submit this for a mainline merge then I
> would encourage you to stop feature work at the earliest reasonable
> stage and then move into the document, submit, review, merge, fixfixfix
> phase.  That might take as long as several months.
> 
> Once things have stabilised and it's usable and performs respectably,
> start thinking about features again.
> 
> Do NOT fall into the trap of adding more and more and more stuff to an
> out-of-tree project.  It just makes it harder and harder to get it
> merged.  There are many examples of this.

I think I was getting all geared up to be another example of that.  Ok,
"usable" to me means with atomic commit and SMP locking, and doesn't
immediately oops.  And put the versioning and directory index aside for
the moment, which is not a big question mark because we have done both
before.
 
> Also, don't feel that a merge would lock you into the current on-disk
> layout.  I think it would be acceptable to emit a big printk("the
> format of this fs will change without notice.  Do not yet store any
> data on a tux3 fs") during mount().   For a while.

Got it.

Regards,

Daniel
