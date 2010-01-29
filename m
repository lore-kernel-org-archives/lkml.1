Return-Path: <linux-kernel-owner+w=401wt.eu-S932158Ab0A2QvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab0A2QvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502Ab0A2QvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:51:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:42884 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab0A2QvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:51:19 -0500
Subject: Re: [RFC 0/2 PATCH] remove member rt_se from struct rt_rq
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, rusty <rusty@rustcorp.com.au>
In-Reply-To: <2674af741001282256l3058d356p752b49c024c47e1c@mail.gmail.com>
References: <2674af741001282256l3058d356p752b49c024c47e1c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 17:51:07 +0100
Message-ID: <1264783867.24455.11.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 14:56 +0800, Yong Zhang wrote:
> member rt_se of struct rt_rq is a duplicate of tg->rt_se[cpu].
> So we can remove one of them. After checking CFS, I think
> rt_rq->rt_se can be removed for some kinds of consistence.

Looks good I think.

