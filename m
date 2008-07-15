Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbYGOW41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbYGOW41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbYGOW4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:56:18 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:40143 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbYGOW4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:56:17 -0400
Subject: Re: [PATCH 2/7] dynamic debug v2 - nfs conversion
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
       greg@kroah.com, nick@nick-andrew.net, randy.dunlap@oracle.com
In-Reply-To: <20080715154323.b7d5f14d.akpm@linux-foundation.org>
References: <20080715213241.GC23331@redhat.com>
	 <1216161003.7981.73.camel@localhost>
	 <20080715154323.b7d5f14d.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 18:56:07 -0400
Message-Id: <1216162567.7981.82.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 33CD9D71F544F349CBBFA7DE9E1F861FCE7E3C7F
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 188 total 9205455 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 15:43 -0700, Andrew Morton wrote:
> On Tue, 15 Jul 2008 18:30:03 -0400
> Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> > On Tue, 2008-07-15 at 17:32 -0400, Jason Baron wrote:
> > > -convert sunrpc debug facility
> > > 
> > > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > > 
> > 
> > Where the hell did this come from, what's its purpose, and WTF haven't
> > you Cced linux-nfs@vger.kernel.org so that the rest of us can review it?
> 
> It's on linux-kernel.  If you don't have a linux-kernel subscription
> then you should fix that.  Set up a procmail rule and do a
> search-by-subject when needed.

I get my daily share of 1000-odd mails from linux-kernel, thanks, but
99% of that goes into the trashcan. I only keep a mail if I see that
it's relevant. In this case, 1 email out of 7 turns out to be relevant
(after I inadvertently deleted the apparently crucial first 2 emails),
and there is no changelog entry to tell me what's being done or why.

By Ccing the correct list, we at least get a heads-up that this thread
might be important. I can't archive all of lkml on my laptop, but I can
and do archive all of linux-nfs...

> In this case, yes, it would have been nice if Jason had cc'ed lots of
> different lists and individuals on the core patch and then selectively
> cc'ed lists and individuals on the per-subsystem followup patches.  But
> I doubt if even 2% of patch submitters manage to do all that correctly.

The point is that he is changing a semi-official interface for tracing
the NFS kernel activity from userspace. I'd like to know why and how it
is being modified before I can ack it.

In addition there are several other developers who have a daily interest
in using this interface when helping our users, and who might have
comments.

 Trond

