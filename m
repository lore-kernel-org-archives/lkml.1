Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbZK3KDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbZK3KDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 05:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbZK3KDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 05:03:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59701 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258AbZK3KDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 05:03:31 -0500
Date: Mon, 30 Nov 2009 11:00:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2.6.32-rc6] sched, kvm: fix race condition involving
 sched_in_preempt_notifers
Message-ID: <20091130100049.GA7054@elte.hu>
References: <4AFD2801.7020900@kernel.org>
 <20091113095516.GD1364@elte.hu>
 <4AFEAB6D.60600@redhat.com>
 <4B138BC8.3090008@kernel.org>
 <4B13942E.3000002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B13942E.3000002@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 11/30/2009 11:09 AM, Tejun Heo wrote:
> >
> >>
> >>>   but we want to do sched.c changes via
> >>>the scheduler tree.
> >So, this one was a bust.  Given that the only platform which might
> >have been affected by the original bug is ia64 and it's very unlikely
> >to happen.  I think reverting this from sched/urgent would be the
> >right thing to do at this point if the branch is headed for another
> >push to Linus.  Avi, what do you think?
> 
> I agree.

that sched/urgent commit is not queued up for 2.6.32 (Linus indicated 
there wont be an -rc9), it spills over to the 2.6.33 merge window.

	Ingo
