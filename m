Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229Ab0AUKqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab0AUKqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 05:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484Ab0AUKqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 05:46:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52324 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab0AUKqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 05:46:53 -0500
Subject: Re: [PATCH] perf_events: improve x86 event scheduling (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com
In-Reply-To: <bd4cb8901001210243y16dbbf8doe66cf24d15120443@mail.gmail.com>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
	 <1264070181.4283.1149.camel@laptop>
	 <bd4cb8901001210243y16dbbf8doe66cf24d15120443@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jan 2010 11:46:25 +0100
Message-ID: <1264070785.4283.1152.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 11:43 +0100, Stephane Eranian wrote:
> On Thu, Jan 21, 2010 at 11:36 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2010-01-18 at 10:58 +0200, Stephane Eranian wrote:
> >>  void hw_perf_enable(void)
> >>  {
> >
> >
> >> +               cpuc->n_added = 0;
> >> +               perf_events_lapic_init();
> >
> > Just wondering, why do we need that lapic_init() there?
> >
> I think I picked it up from x86_pmu_enable(). I don't think
> you necessarily need it here. Not clear to me why it was
> in x86_pmu_enable() to begin with.

Right, wondering about the same ;-)

> I will post a new version of the patch which fixes some bugs and
> also implements true fast path (reuse of previous assignment). It turned
> out, things were a bit more complicated than what I had in v5.

Could you post a diff against your previous version, I just picked up
-v5 and tidied a few things up and send it mingo wards (although it
appears he hasn't picked it up yet).



