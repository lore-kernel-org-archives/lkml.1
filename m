Return-Path: <linux-kernel-owner+w=401wt.eu-S1751984AbZGXAjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbZGXAjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 20:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbZGXAjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 20:39:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57633 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbZGXAjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 20:39:53 -0400
Message-ID: <4A69027A.305@cn.fujitsu.com>
Date: Fri, 24 Jul 2009 08:38:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 1/2] function-graph: fix the output of set_graph_function
References: <4A66D004.7020205@cn.fujitsu.com> <alpine.DEB.2.00.0907232034510.8469@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0907232034510.8469@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 22 Jul 2009, Li Zefan wrote:
> 
>> It always shows "ftrace_graph_funcs":
>>
>>  # echo 'sys_open' > set_graph_function
>>  # cat set_graph_function
>>  ftrace_graph_funcs
> 
> Nice fix. Hmm, this probably should go into 31.
> 

The bug is introduced by a patch in tracing/core,
so this fix is for -tip only. :)

