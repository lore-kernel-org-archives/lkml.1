Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935572Ab0BZIiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 03:38:51 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:50408 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935550Ab0BZIiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 03:38:50 -0500
Message-Id: <201002260838.o1Q8cfr2068194@www262.sakura.ne.jp>
Subject: Re: [RFC][PATCH] mm: Remove ZERO_SIZE_PTR.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: kosaki.motohiro@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Feb 2010 17:38:41 +0900
References: <201002260635.o1Q6ZYET040848@www262.sakura.ne.jp> <20100226155618.8D9E.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100226155618.8D9E.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 26022010 #3421565, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> > Therefore, at the cost of being unable to distinguish "NULL pointer
> > dereference" and "ZERO_SIZE_PTR dereference" in some cases, removing
> > ZERO_SIZE_PTR could reduce the risk of "ZERO_SIZE_PTR dereference" in many
> > cases.
> 
> NAK. yes, it could. but it is no worth. nobody want slower kernel.
> 
This patch simplifies error checks of both callers/callees from

	((unsigned long)(x) <= (unsigned long) 16)

to

	!(x)

. Why this patch makes the kernel slower?
