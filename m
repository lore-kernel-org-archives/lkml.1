Return-Path: <linux-kernel-owner+w=401wt.eu-S932999AbYAaMNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999AbYAaMNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 07:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764377AbYAaMM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 07:12:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39701 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764086AbYAaMM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 07:12:57 -0500
Subject: Re: Hang in work_resched
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Guillaume Chazarain <guichaz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <3d8471ca0801310329o5620ac39qe3a0c39f2c0baa49@mail.gmail.com>
References: <3d8471ca0801291430n68c0a845u1b24a590df8360f4@mail.gmail.com>
	 <3d8471ca0801301454l56dd8607g25aad3ac3cd88e75@mail.gmail.com>
	 <1201769710.28547.248.camel@lappy>
	 <3d8471ca0801310329o5620ac39qe3a0c39f2c0baa49@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 13:12:25 +0100
Message-Id: <1201781545.28547.298.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-31 at 12:29 +0100, Guillaume Chazarain wrote:
> On Jan 31, 2008 9:55 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > Does this patch from thomas fix it as well?
> 
> Unfortunately, not.
> 
> For information, reverting just the first part of the offending commit
> (sl->timer.cb_mode) fixed the problem, while reverting only the second
> part (if (!hrtimer_active(&t->timer))) had no effect.
> 
> Also, I found a trivially reproductible testcase : sleep 0.
> 
> It hangs in nanosleep({0, 0}).

works for me :-( (x86_64 rawhide userspace)

Could you send your .config?

