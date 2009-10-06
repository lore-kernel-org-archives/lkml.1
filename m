Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbZJFIl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbZJFIl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 04:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755079AbZJFIl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 04:41:58 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49824 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbZJFIl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 04:41:57 -0400
Date: Tue, 6 Oct 2009 10:41:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Valdis.Kletnieks@vt.edu, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, riel@redhat.com
Subject: Re: Do we support ioprio on SSDs with NCQ (Was: Re: IO scheduler
	based IO controller V10)
Message-ID: <20091006084120.GJ5216@kernel.dk>
References: <20091002195815.GE4494@redhat.com> <4e5e476b0910021514i1b461229t667bed94fd67f140@mail.gmail.com> <20091002222756.GG4494@redhat.com> <4e5e476b0910030543o776fb505ka0ce38da9d83b33c@mail.gmail.com> <20091003133810.GC12925@redhat.com> <4e5e476b0910040215m35af5c99pf2c3a463a5cb61dd@mail.gmail.com> <20091004121122.GB18778@redhat.com> <4e5e476b0910040546h5f77cd1fo3172fe5c229eb579@mail.gmail.com> <x49my457uef.fsf@segfault.boston.devel.redhat.com> <4e5e476b0910051409x33f8365flf32e8e7548d72e79@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0910051409x33f8365flf32e8e7548d72e79@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05 2009, Corrado Zoccolo wrote:
> On Mon, Oct 5, 2009 at 5:06 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> > Corrado Zoccolo <czoccolo@gmail.com> writes:
> >
> >> Moreover, I suggest removing also the slice_resid part, since its
> >> semantics doesn't seem consistent.
> >> When computed, it is not the residency, but the remaining time slice.
> >
> > It stands for residual, not residency.  Make more sense?
> It makes sense when computed, but not when used in rb_key computation.
> Why should we postpone queues that where preempted, instead of giving
> them a boost?

We should not, if it is/was working correctly, it should allow both for
increase/descrease of tree position (hence it's a long and can go
negative) to account for both over and under time.

-- 
Jens Axboe

