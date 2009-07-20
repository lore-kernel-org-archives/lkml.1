Return-Path: <linux-kernel-owner+w=401wt.eu-S1752242AbZGTBTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbZGTBTr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 21:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbZGTBTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 21:19:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60295 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbZGTBTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 21:19:45 -0400
Message-ID: <4A63C5CD.7010204@cn.fujitsu.com>
Date: Mon, 20 Jul 2009 09:18:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] tracing/events: 2 fixes for dynamic arrays
References: <4A5E9604.2030103@cn.fujitsu.com>
In-Reply-To: <4A5E9604.2030103@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Could you have a look at these 2 patches?

> These 2 fixes are necessary to make __dynamic_array/__string
> parsable for users.
> 
> And also fix to pass the correct string length when filtering
> on dynamic strings.
> 
> [PATCH 1/2] tracing/events: add missing type info of dynamic arrays
> [PATCH 2/2] tracing/events: record the size of dynamic arrays
> ---
>  include/trace/ftrace.h             |   18 ++++++++++--------
>  kernel/trace/trace_events_filter.c |    6 ++++--
>  2 files changed, 14 insertions(+), 10 deletions(-)
