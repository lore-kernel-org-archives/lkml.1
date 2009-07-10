Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbZGJFXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbZGJFXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 01:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZGJFXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 01:23:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62642 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbZGJFXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 01:23:34 -0400
Message-ID: <4A56D053.2050909@cn.fujitsu.com>
Date: Fri, 10 Jul 2009 13:23:31 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/filter: remove preds from struct event_subsystem
References: <4A55A83C.1030005@cn.fujitsu.com>
In-Reply-To: <4A55A83C.1030005@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiao Guangrong wrote:
> No need to save preds to event_subsystem, because it's not used.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Nice cleanup.

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

> ---
>  kernel/trace/trace_events_filter.c |   39 +++++------------------------------
>  1 files changed, 6 insertions(+), 33 deletions(-)
