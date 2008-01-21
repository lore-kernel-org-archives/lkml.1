Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbYAUIH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbYAUIH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 03:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757789AbYAUIHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 03:07:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40591 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757749AbYAUIHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 03:07:13 -0500
Date: Mon, 21 Jan 2008 17:06:53 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: LatencyTOP infrastructure patch
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080118093943.0048d0f7@laptopd505.fenrus.org>
References: <4790E3A6.7060807@linux.intel.com> <20080118093943.0048d0f7@laptopd505.fenrus.org>
Message-Id: <20080121170415.125B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> +static void __sched
> +account_global_scheduler_latency(struct task_struct *tsk, int usecs)
> +{
> +	int i;
> +	int firstnonnull = MAXLR + 1;
> +
> +	if (!tsk->latency_reason.reason)
> +		return;
> +
> +	/* skip kernel threads for now */
> +	if (!tsk->mm)
> +		return;

Why do you ignore kernel thread?

may be, some network filesystem use kernel thread for local I/O.
What do you think it?


- kosaki

