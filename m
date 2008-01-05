Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbYAEAk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbYAEAk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 19:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbYAEAkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 19:40:18 -0500
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:55874 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753633AbYAEAkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 19:40:16 -0500
Date: Fri, 4 Jan 2008 19:39:51 -0500
From: Theodore Tso <tytso@mit.edu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Mathieu Segaud <mathieu.segaud@regala.cx>, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [Coding Style]: misc fixes for fs/ext{3,4}/acl.{c,h}
	from checkpatch.pl
Message-ID: <20080105003951.GM17436@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mathieu Segaud <mathieu.segaud@regala.cx>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx> <20080104134458.GE17436@mit.edu> <p73hcht8sfr.fsf@bingen.suse.de> <20080104190137.GJ17436@mit.edu> <20080104194129.GA16962@one.firstfloor.org> <4d8e3fd30801041203s2f017f20ld9fcbc82912468fe@mail.gmail.com> <20080104223328.GB19248@one.firstfloor.org> <4d8e3fd30801041612k2b4aaab1yee2be5eec03e9f07@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d8e3fd30801041612k2b4aaab1yee2be5eec03e9f07@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 01:12:44AM +0100, Paolo Ciarrocchi wrote:
> Isn't it a timing problem?
> I mean, I guess that codying style fixes are OK if there is a good coordination
> with the maintainer and patches are sent with the right timing in
> order to not cause
> problems in the process.

But because running some kind of mechanical script and fixing up the
problems is relatively mindless, it doesn't *add* anything.  Only the
maintainer knows when it is a reasonably convenient time to fix all of
the problems, or when to fix portions of the code that is being
reworked anyway --- and the maintainer can just run the script by
himself, for himself.  The patch doesn't actually save him much work,
and in some cases, is actually more work than simply regenerating the
fixes *after* the other patches waiting in his patch queue have been
applied (but of course, it screws up everyone else's patches that
haven't been submitted to the maintainer yet).

In some cases, it's worth it.  In other (most) cases, it really isn't.

   	       	    	       	  	       - Ted
