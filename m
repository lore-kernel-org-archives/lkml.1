Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab0CKJC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 04:02:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35180 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab0CKJC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:02:56 -0500
Date: Thu, 11 Mar 2010 04:02:48 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: export perf_trace_regs and
	perf_arch_fetch_caller_regs
Message-ID: <20100311090248.GA10904@infradead.org>
References: <4B989C1B.2090407@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B989C1B.2090407@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 03:30:35PM +0800, Xiao Guangrong wrote:
> Export perf_trace_regs and perf_arch_fetch_caller_regs since module will
> use these

What modules exactly?  Uusually you add the export together with the
series adding the users.

