Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbXKXMZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbXKXMZZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 07:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbXKXMZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 07:25:16 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:41013 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbXKXMZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 07:25:14 -0500
Date: Sat, 24 Nov 2007 15:25:11 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alasdair G Kergon <agk@redhat.com>,
       Milan Broz <mbroz@redhat.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debug_check_no_locks_freed: fix in_range() checks
Message-ID: <20071124122511.GA2219@tv-sign.ru>
References: <20071120234605.GG23667@elte.hu> <20071121155842.GA864@tv-sign.ru> <20071124105343.GA2044@tv-sign.ru> <64bb37e0711240418i2e90916dx3f1b622df0e2f8b3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0711240418i2e90916dx3f1b622df0e2f8b3@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24, Torsten Kaiser wrote:
>
> On Nov 24, 2007 11:53 AM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
> > Torsten, could you ack/nack this patch?
> 
> From looking at the code I would ack it.

Great.

> I will reapply agk-dm-dm-crypt-move-bio-submission-to-thread.patch and
> this patch and boot several times, but as the message was not
> triggered on every boot, this can't prove anything.

Regardless of any other possible problems, I think you found a real bug
in debug_check_no_locks_freed() which should be fixed.

Oleg.

