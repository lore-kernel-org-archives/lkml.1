Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbXKXMfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbXKXMfw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 07:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbXKXMfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 07:35:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbXKXMfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 07:35:43 -0500
Date: Sat, 24 Nov 2007 12:35:13 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debug_check_no_locks_freed: fix in_range() checks
Message-ID: <20071124123513.GF22843@agk.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Torsten Kaiser <just.for.lkml@googlemail.com>,
	Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
	Milan Broz <mbroz@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20071120234605.GG23667@elte.hu> <20071121155842.GA864@tv-sign.ru> <20071124105343.GA2044@tv-sign.ru> <64bb37e0711240418i2e90916dx3f1b622df0e2f8b3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0711240418i2e90916dx3f1b622df0e2f8b3@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2007 at 01:18:35PM +0100, Torsten Kaiser wrote:
> I will reapply agk-dm-dm-crypt-move-bio-submission-to-thread.patch and
> this patch and boot several times

OK for a test system, but until the write loop problem is addressed I believe
there's a risk of data corruption under low memory conditions.  (I dropped it
from the export to -mm a few days ago for this reason.)

Alasdair
-- 
agk@redhat.com
