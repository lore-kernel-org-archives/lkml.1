Return-Path: <linux-kernel-owner+w=401wt.eu-S1752268AbZGVR5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbZGVR5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbZGVR5C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:57:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35828 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZGVR5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:57:01 -0400
Subject: Re: [tip:sched/core] sched: Pull up the might_sleep() check into 
 cond_resched()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <c62985530907221017i427b1ae1s8cbb593106c658a1@mail.gmail.com>
References: <1247725694-6082-6-git-send-email-fweisbec@gmail.com>
	 <tip-613afbf83298efaead05ebcac23d2285609d7160@git.kernel.org>
	 <4A6413AB.2050807@cn.fujitsu.com> <20090720081210.GA5309@nowhere>
	 <1248089955.15751.8494.camel@twins>
	 <c62985530907221017i427b1ae1s8cbb593106c658a1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jul 2009 19:56:43 +0200
Message-Id: <1248285403.4711.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 19:17 +0200, Frédéric Weisbecker wrote:

> Ah, I think I've got it. In case of !CONFIG_PREEMPT, the spinlocks of
> course don't play
> with preemption, making no change reflected in the preempt_count().
> The assumption of preempt_count() = 1
> is then false.

D'0h indeed. And I didn't hit that because the last time I build a !
CONFIG_PREEMPT kernel is like many years ago ;-)



