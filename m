Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbZLUJPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbZLUJPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 04:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZLUJPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 04:15:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64340 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbZLUJPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 04:15:30 -0500
Message-ID: <4B2F3C40.6030601@cn.fujitsu.com>
Date: Mon, 21 Dec 2009 17:13:36 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: different symbol address between System.map and /proc/kallsyms
References: <4B2ECD47.7040202@cn.fujitsu.com> <4B2F1630.7090406@zytor.com>
In-Reply-To: <4B2F1630.7090406@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



H. Peter Anvin wrote:

> 
> That is normal if you have a relocatable kernel which has been loaded at
> the non-compile-time default address.
> 

Yeah, i see, thank you very much.

But, anyway, perf should know this case, i'll fix it.

Thanks,
Xiao
