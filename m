Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbYE0Kfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbYE0Kfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 06:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882AbYE0Kfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 06:35:36 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:35460 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756825AbYE0Kff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 06:35:35 -0400
Date: Mon, 26 May 2008 15:22:47 -0400
From: Theodore Tso <tytso@mit.edu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10732] REGRESSION: 2.6.26-rc2-git4: X server failed
	start on X61s laptop
Message-ID: <20080526192247.GA7515@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Hugh Dickins <hugh@veritas.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik> <TW_YzGo9TFP.A.VVD.WeIOIB@albercik> <Pine.LNX.4.64.0805261115470.3720@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805261115470.3720@blonde.site>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 11:24:02AM +0100, Hugh Dickins wrote:
> On Sat, 24 May 2008, Rafael J. Wysocki wrote:
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10732
> > Subject		: REGRESSION: 2.6.26-rc2-git4: X server failed start on X61s laptop
> > Submitter	: Theodore Ts'o <tytso@mit.edu>
> > Date		: 2008-05-17 7:32 (8 days old)
> > References	: http://marc.info/?l=linux-kernel&amp;m=121100994722524&amp;w=4
> 
> I believe this was fixed by Jeremy's PTE_MASK fixes in 2.6.26-rc3-git2,
> but can only say that they fixed my own X with PAE since PAT mods problem.
> 
> Ted, when you have a chance, please try a recent kernel and let us
> know if this regression can now be removed from the list - thanks.

Yes, I just tried it, with a freshly pulled mainline, and the problem
looks like it has been fixed.  So we can close out the bug and remove
it from the regression list.

						- Ted
