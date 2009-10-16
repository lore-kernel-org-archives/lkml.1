Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbZJPOOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbZJPOOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 10:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760012AbZJPOOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 10:14:09 -0400
Received: from thunk.org ([69.25.196.29]:54436 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759613AbZJPOOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 10:14:08 -0400
Date: Fri, 16 Oct 2009 09:06:38 -0400
From: Theodore Tso <tytso@mit.edu>
To: Parag Warudkar <parag.lkml@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug 14354] Re: ext4 increased intolerance to unclean shutdown?
Message-ID: <20091016130638.GA8196@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Parag Warudkar <parag.lkml@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	bugzilla-daemon@bugzilla.kernel.org
References: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com> <20091016091558.GA10184@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091016091558.GA10184@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 05:15:58AM -0400, Theodore Tso wrote:
> These are three commits that seem most likely, but there are
> only 93 ext4-related commits, so doing a "git bisect start v2.6.31
> v2.6.32-rc5 -- fs/ext4 fs/jbd2" 

One correction.  The git bsect start usage is:

     git bisect start [<bad> [<good>...]] [--] [<paths>...]

So the correct git bisect start command should be:

     git bisect start v2.6.32-rc5 v2.6.31 -- fs/ext4 fs/jbd2

And similarly, "git bisect start v2.6.31 v2.6.31-rc3" should have been:

     git bisect start v2.6.31-rc3 v2.6.31

My apologies for any confusion.

						- Ted
