Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbZJEVJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbZJEVJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 17:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbZJEVJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 17:09:58 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:50851 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbZJEVJ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 17:09:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PXZMYxId2zKTs4faJtaarXuPq4tSWtbeDe4KfqA6im9d+sZW5z3fulY8u60C/DtqJ2
         o5wRAeOkU2cdU2X0e10w2rMeoDnHA1Unp+oR7oVlY8l68XqKvEjQxhMGAQBvjRcFrT1t
         Mlmq1mebZ8q72AabHYLNbgZlusx2AuTGOvr8A=
MIME-Version: 1.0
In-Reply-To: <x49my457uef.fsf@segfault.boston.devel.redhat.com>
References: <4e5e476b0910020827s23e827b1n847c64e355999d4a@mail.gmail.com>
	 <20091002195815.GE4494@redhat.com>
	 <4e5e476b0910021514i1b461229t667bed94fd67f140@mail.gmail.com>
	 <20091002222756.GG4494@redhat.com>
	 <4e5e476b0910030543o776fb505ka0ce38da9d83b33c@mail.gmail.com>
	 <20091003133810.GC12925@redhat.com>
	 <4e5e476b0910040215m35af5c99pf2c3a463a5cb61dd@mail.gmail.com>
	 <20091004121122.GB18778@redhat.com>
	 <4e5e476b0910040546h5f77cd1fo3172fe5c229eb579@mail.gmail.com>
	 <x49my457uef.fsf@segfault.boston.devel.redhat.com>
Date: Mon, 5 Oct 2009 23:09:21 +0200
Message-ID: <4e5e476b0910051409x33f8365flf32e8e7548d72e79@mail.gmail.com>
Subject: Re: Do we support ioprio on SSDs with NCQ (Was: Re: IO scheduler 
	based IO controller V10)
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Valdis.Kletnieks@vt.edu,
       Mike Galbraith <efault@gmx.de>, Jens Axboe <jens.axboe@oracle.com>,
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 5, 2009 at 5:06 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
>
>> Moreover, I suggest removing also the slice_resid part, since its
>> semantics doesn't seem consistent.
>> When computed, it is not the residency, but the remaining time slice.
>
> It stands for residual, not residency.  Make more sense?
It makes sense when computed, but not when used in rb_key computation.
Why should we postpone queues that where preempted, instead of giving
them a boost?

Thanks,
Corrado

>
> Cheers,
> Jeff
>
