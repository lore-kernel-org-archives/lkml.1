Return-Path: <linux-kernel-owner+w=401wt.eu-S1761299AbYD3OsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761299AbYD3OsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 10:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757098AbYD3Or7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 10:47:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004AbYD3Or6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 10:47:58 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-aio <linux-aio@kvack.org>, Zach Brown <zach.brown@oracle.com>,
       Clark Williams <williams@redhat.com>
Subject: Re: AIO/DIO lockup/crash
References: <1209385782.13978.17.camel@twins>
	<20080428090857.beb19a20.akpm@linux-foundation.org>
	<1209404909.13978.23.camel@twins>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 30 Apr 2008 10:46:35 -0400
In-Reply-To: <1209404909.13978.23.camel@twins> (Peter Zijlstra's message of
	"Mon, 28 Apr 2008 19:48:29 +0200")
Message-ID: <x49tzhjcsdw.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Mon, 2008-04-28 at 09:08 -0700, Andrew Morton wrote:
>
>> erk, that's dio->bio_lock, isn't it?
>
> Yep.
>
>> That lock is super-simple and hasn't changed in quite some time.  If there
>> has been major memory wreckage and we're simply grabbing at a "lock" in
>> random memory then I'd expect the bug to maninfest in different ways on
>> different runs?
>
> Looks like it.
>
>> I assume you have lots of runtime debugging options enabled.
>
> Not on this particular run. I'll start a -git run this evening with most
> of the debugging option enabled. It takes a few hours to reproduce, so I
> let it run over-night.

Peter, any update on this?

FWIW, I've been running the aio-dio-invalidate-failure test on a fedora
kernel (2.6.25-8.fc9.i686) for several days now without any problems.
However, I'm not sure I can reproduce the bugs at all.  I'll revert to a
2.6.24 kernel and try.

Cheers,

Jeff
