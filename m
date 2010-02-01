Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab0BAJVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 04:21:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57457 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab0BAJVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 04:21:45 -0500
Subject: Re: [RFC 0/2 PATCH] remove member rt_se from struct rt_rq
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, rusty <rusty@rustcorp.com.au>
In-Reply-To: <2674af741001312112k517ed073w51e66a907438f301@mail.gmail.com>
References: <2674af741001282256l3058d356p752b49c024c47e1c@mail.gmail.com>
	 <1264783867.24455.11.camel@laptop>
	 <2674af741001312112k517ed073w51e66a907438f301@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 10:21:36 +0100
Message-ID: <1265016096.24455.108.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 13:12 +0800, Yong Zhang wrote:
> On Sat, Jan 30, 2010 at 12:51 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, 2010-01-29 at 14:56 +0800, Yong Zhang wrote:
> >> member rt_se of struct rt_rq is a duplicate of tg->rt_se[cpu].
> >> So we can remove one of them. After checking CFS, I think
> >> rt_rq->rt_se can be removed for some kinds of consistence.
> >
> > Looks good I think.
> 
> Hi Peter,
> 
> Seems nobody has objection on the two patches.
> Can you pick them up?

I'll take them, thanks!

