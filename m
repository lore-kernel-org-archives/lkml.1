Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbZJFIy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbZJFIy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 04:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756576AbZJFIy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 04:54:59 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47016 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756566AbZJFIy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 04:54:58 -0400
Date: Tue, 6 Oct 2009 10:54:21 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: bug in elevator/cfq regarding start_time?
Message-ID: <20091006085421.GL5216@kernel.dk>
References: <4e5e476b0910041354o54c95626g974264976adaf53c@mail.gmail.com> <20091004205955.GM26573@kernel.dk> <4e5e476b0910050808k3a26aad8r19a145fc60e1da6b@mail.gmail.com> <4e5e476b0910051326g559bf135ma3cf82219ade497@mail.gmail.com> <20091006071202.GC5216@kernel.dk> <4e5e476b0910060143o7af4798q22600d396a5fbbcd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0910060143o7af4798q22600d396a5fbbcd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06 2009, Corrado Zoccolo wrote:
> On Tue, Oct 6, 2009 at 9:12 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Mon, Oct 05 2009, Corrado Zoccolo wrote:
> >> On Mon, Oct 5, 2009 at 5:08 PM, Corrado Zoccolo <czoccolo@gmail.com> wrote:
> >> False alarm. I just found that the list was not yet filled at that
> >> place in the code.
> >
> > OK, it did look a bit puzzling. FWIW, this is what I committed
> > yesterday:
> >
> > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=30996f40bffe73f05abb92a4cec254befa8cecf7
> Yes, I was testing this one, but put the testing code in the wrong place.
> After fixing the testing code, I verified it is working correctly.
> Now, both the start time and fifo_time are monotonic.

OK good, thanks for confirming! I'll push it for 2.6.32. And thanks for
spotting this in the first place, the fixing part was the easy bit.

-- 
Jens Axboe

