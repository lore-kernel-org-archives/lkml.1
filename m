Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbZGPJba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbZGPJba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 05:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbZGPJba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 05:31:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56160 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754248AbZGPJb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 05:31:29 -0400
Message-ID: <4A5EF315.7080909@cn.fujitsu.com>
Date: Thu, 16 Jul 2009 17:29:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/function: simplify for __ftrace_replace_code()
References: <4A5D5B12.2050802@cn.fujitsu.com> <4A5D5BCF.4070707@cn.fujitsu.com>
In-Reply-To: <4A5D5BCF.4070707@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiao Guangrong wrote:
> Rewrite the __ftrace_replace_code() function, let it's simple, but
> not change the code's logic.
> 
> First, we get the state we want to set, if the record has the same
> state, then do nothing, if not, enable/disable it.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

> ---
>  kernel/trace/ftrace.c |   75 +++++++++++++-----------------------------------
>  1 files changed, 21 insertions(+), 54 deletions(-)
