Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbZFWK2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbZFWK2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 06:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZFWK2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 06:28:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54190 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZFWK2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 06:28:15 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: merging the per-bdi writeback patchset
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hch@infradead.org
In-Reply-To: <20090623085505.GU31415@kernel.dk>
References: <20090623014835.1fc8fb14.akpm@linux-foundation.org> <20090623085505.GU31415@kernel.dk>
Message-Id: <20090623191803.2230.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 23 Jun 2009 19:28:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> On Tue, Jun 23 2009, Andrew Morton wrote:
> > On Tue, 23 Jun 2009 10:11:56 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > Things are looking good for this patchset and it's been in -next for
> > > almost a week without any reports of problems. So I'd like to merge it
> > > for 2.6.31 if at all possible. Any objections?
> > 
> > erk.  I was rather expecting I'd have time to have a look at it all.
> 
> OK, we can wait if we have to, just trying to avoid having to keep this
> fresh for one full cycle. I have posted this patchset 11 times though
> over months, so it's not like it's a new piece of work :-)
> 
> > It's unclear to me actually _why_ the performance changes which were
> > observed have actually occurred.  In fact it's a bit unclear (to me)
> > why the patchset was written and what it sets out to achieve :(
> 
> It started out trying to get rid of the pdflush uneven writeout. If you
> look at various pdflush intensive workloads, even on a single disk you
> often have 5 or more pdflush threads working the same device. It's just
> not optimal. Another issue was starvation with request allocation. Given
> that pdflush does non-blocking writes (it has to, by design), pdflush
> can potentially be starved if someone else is working the device.

Can you please make reproduce program and post mesurement result?
I hope to mesure the same program on my box.

Plus, Can you please write more vervose patch description? your patch is a
bit harder review.



