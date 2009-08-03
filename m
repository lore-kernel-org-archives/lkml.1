Return-Path: <linux-kernel-owner+w=401wt.eu-S1751510AbZHCFll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbZHCFll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 01:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZHCFlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 01:41:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58647 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbZHCFlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 01:41:40 -0400
Message-ID: <4A76782E.4030803@cn.fujitsu.com>
Date: Mon, 03 Aug 2009 13:39:58 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 4/5] tracing/filters: Provide basic regex support
References: <1249111408-8657-1-git-send-email-fweisbec@gmail.com> <1249111408-8657-5-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1249111408-8657-5-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> This patch provides basic support for regular expressions in filters.
> The common filter file doesn't support any regex but a new
> filter_regex file is created for each subsystem/event.
> 
> It supports the following types of regexp:
> 
> - *match_beginning
> - *match_middle*
> - match_end*
> - !don't match
> 

I don't see why adding "filter_regex" is necessary, why not just make
"filter" support regex?

> Every string is now handled as a regexp in the filter framework, which
> helps to factorize the code for handling both simple strings and
> regexp comparisons.
> 
> (The regexp code has been savagely cherry picked from ftrace.c
> writtent by Steve. If this patch makes its way, I'll be happy
> to change ftrace to use the new filter helpers)
