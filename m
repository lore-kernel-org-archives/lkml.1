Return-Path: <linux-kernel-owner+w=401wt.eu-S1758474AbZBEQSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474AbZBEQSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbZBEQSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:18:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56124 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203AbZBEQSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:18:39 -0500
Date: Thu, 5 Feb 2009 17:15:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kaz Kylheku <kkylheku@gmail.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: main thread pthread_exit/sys_exit bug!
Message-ID: <20090205161544.GA24799@redhat.com>
References: <3f43f78b0902011432y354c1b35m8f645640433f7b49@mail.gmail.com> <20090201174159.4a52e15c.akpm@linux-foundation.org> <20090202064509.GA20237@redhat.com> <3f43f78b0902012310p46186417m66873f410b948fd3@mail.gmail.com> <20090202165606.GA13346@redhat.com> <20090205030553.49650FC381@magilla.sf.frob.com> <3f43f78b0902042055p37ff9ab2u84840273b34c7373@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f43f78b0902042055p37ff9ab2u84840273b34c7373@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Kaz Kylheku wrote:
>
> On Wed, Feb 4, 2009 at 7:05 PM, Roland McGrath <roland@redhat.com> wrote:
> > I haven't seen the clear explanation of what specific actual problems there
> > are here.  But I'm quite sure this is not the right approach to address them.
> >
> > Kaz has said things that seemed to imply that the behavior is erratic or
> > the semantics are somehow ill-defined when the group leader has died with
> > other threads living on.  In fact, this case is perfectly well-specified
> > and there is no mystery about it.
>
> I haven't observed anything that could be called erratic. The behavior that
> occurs, occurs reliably.

Yes we have the bug, and wait_task_stopped() should be fixed. But it is
buggy anyway, even if we delay the death of the main thread. But I also
think we shouldn't.

(and I am sorry, I still can't find the time to redo my old patch, will
 try to do this asap).

Oleg.

