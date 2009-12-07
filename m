Return-Path: <linux-kernel-owner+w=401wt.eu-S1759003AbZLGIOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003AbZLGIOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758882AbZLGIOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:14:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58412 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758880AbZLGIOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:14:18 -0500
Subject: Re: [tip:perf/urgent] perf_event: Eliminate raw->size
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com,
       hirofumi@mail.parknet.co.jp, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-f48f669d42e133db839af16656fd720107ef6742@git.kernel.org>
References: <4B1C8CC4.4050007@cn.fujitsu.com>
	 <tip-f48f669d42e133db839af16656fd720107ef6742@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Dec 2009 09:13:49 +0100
Message-ID: <1260173629.8223.1068.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 05:31 +0000, tip-bot for Xiao Guangrong wrote:
> Commit-ID:  f48f669d42e133db839af16656fd720107ef6742
> Gitweb:     http://git.kernel.org/tip/f48f669d42e133db839af16656fd720107ef6742
> Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> AuthorDate: Mon, 7 Dec 2009 13:04:04 +0800
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 7 Dec 2009 06:26:25 +0100
> 
> perf_event: Eliminate raw->size
> 
> raw->size is not used, this patch just cleans it up.

This patch feels wrong.. I would suspect it to be used to validate the
data parsing, like do we consume past the end and did we consume
everything.

