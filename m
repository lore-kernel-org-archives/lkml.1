Return-Path: <linux-kernel-owner+w=401wt.eu-S1752369AbZLaKu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbZLaKu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 05:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbZLaKuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 05:50:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61699 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbZLaKuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 05:50:54 -0500
Message-ID: <4B3C819D.9000809@cn.fujitsu.com>
Date: Thu, 31 Dec 2009 18:49:01 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] perf tools: adjust symbol address
References: <4B3AC5CD.1000502@cn.fujitsu.com> <4B3AC69F.4070901@cn.fujitsu.com> <20091230131016.GC2956@ghostprotocols.net> <4B3C1397.8040307@cn.fujitsu.com> <20091231102938.GD2384@ghostprotocols.net>
In-Reply-To: <20091231102938.GD2384@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Arnaldo Carvalho de Melo wrote:

>> vmlinux* not know it's relocation or not, and we just handle the _specific_
>> kernel at the time which match the current system. 
> 
> 'perf record' in one machine + 'perf report' in another should be
> possible.
>  

Yeah, but current code not support this since it not record kernel build-id in
perf.data while 'perf record' works, maybe you can fix it.

Xiao
