Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab0BADA1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 22:00:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752366Ab0BADAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 22:00:25 -0500
Date: Sun, 31 Jan 2010 19:00:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/7] sched: Use for_each_bit
Message-Id: <20100131190009.b266a27e.akpm@linux-foundation.org>
In-Reply-To: <961aa3351001311854s40d33804m715d7643fe430b5b@mail.gmail.com>
References: <1264938810-4173-1-git-send-email-akinobu.mita@gmail.com>
	<b6fcc0a1001310406j3924731du4727bd82cb23ea9a@mail.gmail.com>
	<20100131183807.309a902f.akpm@linux-foundation.org>
	<961aa3351001311854s40d33804m715d7643fe430b5b@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Feb 2010 11:54:14 +0900 Akinobu Mita <akinobu.mita@gmail.com> wrote:

> 2010/2/1 Andrew Morton <akpm@linux-foundation.org>:
> > On Sun, 31 Jan 2010 14:06:10 +0200 Alexey Dobriyan <adobriyan@gmail.com> wrote:
> >
> >> On Sun, Jan 31, 2010 at 1:53 PM, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> >> > __#define for_each_cpupri_active(array, idx) __ __ __ __ __ __ __ __ __ __\
> >> > - __for (idx = find_first_bit(array, CPUPRI_NR_PRIORITIES); __ __ \
> >> > - __ __ __ idx < CPUPRI_NR_PRIORITIES; __ __ __ __ __ __ __ __ __ __ __ __ __ __\
> >> > - __ __ __ idx = find_next_bit(array, CPUPRI_NR_PRIORITIES, idx+1))
> >> > + __ __ __ for_each_bit(idx, array, CPUPRI_NR_PRIORITIES)
> >>
> >> It should be called for_each_set_bit().
> >
> > Agree.
> 
> (I'm resending because I failed to reply all)
> 
> You mean for_each_bit() should be renamed to for_each_set_bit() ?

Yes.

> I'm not sure. But if so, find_first_bit() also should be renamed to
> find_first_set_bit() and so on?

Yes, it should have been.  It's a bit late to correct that mistake, but
it's not too late to fix for_each_bit().
