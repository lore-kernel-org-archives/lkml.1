Return-Path: <linux-kernel-owner+w=401wt.eu-S1751903AbZL1IGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbZL1IGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbZL1IGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:06:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39828 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbZL1IGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:06:31 -0500
Date: Mon, 28 Dec 2009 09:06:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH] perf_event: mount debugfs automatically
Message-ID: <20091228080615.GC28652@elte.hu>
References: <4B383DE3.3070702@cn.fujitsu.com>
 <20091228074426.GA20039@elte.hu>
 <4B386615.7000207@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B386615.7000207@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> > But your idea is sound if we only do the first half: we should mount it 
> > under /sys/kernel/debug/ if it's not mounted already [and that directory 
> > is available], and leave it mounted there.
> > 
> 
> Um, i'll rewrite it and just mount it under /sys/kernel/debug

Yeah, i think that will work better. Thanks!

	Ingo
