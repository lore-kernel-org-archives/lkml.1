Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbZDQFdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbZDQFdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 01:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbZDQFdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 01:33:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49924 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbZDQFdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 01:33:33 -0400
Message-ID: <49E814E2.4000600@cn.fujitsu.com>
Date: Fri, 17 Apr 2009 13:34:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tom Zanussi <tzanussi@gmail.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH v2] tracing/filters: add filter_mutex to protect filter
 predicates
References: <1239946028.6639.13.camel@tropicana>
In-Reply-To: <1239946028.6639.13.camel@tropicana>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Zanussi wrote:
> This patch adds a filter_mutex to prevent the filter predicates from
> being accessed concurrently by various external functions.
> 
> It's based on a previous patch by Li Zefan:
>         "[PATCH 7/7] tracing/filters: make filter preds RCU safe"
> 
> v2 changes:
> 
> - fixed wrong value returned in a add_subsystem_pred() failure case
> noticed by Li Zefan.
> 
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> 

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Tested-by: Li Zefan <lizf@cn.fujitsu.com>


