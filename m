Return-Path: <linux-kernel-owner+w=401wt.eu-S1752420AbYJTIuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbYJTIuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 04:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYJTIuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 04:50:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57561 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbYJTIuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 04:50:22 -0400
Message-ID: <48FC45CD.1070101@cn.fujitsu.com>
Date: Mon, 20 Oct 2008 16:48:13 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip/tracing/markers] markers: simplify marker_set_format()
References: <48F59425.40601@cn.fujitsu.com> <20081015134416.GA29281@Krystal>
In-Reply-To: <20081015134416.GA29281@Krystal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
>> current marker_set_format() is complex this patch simplify it, 
>> and decrease the overhead of marker_update_probes().
>>
> 
> Yep, I think I did put the format string after the name \0, which was
> rather tricky. I agree that such change makes the code more readable at
> the expense of doing 2 allocations per marker rather than one, but
> readability might be a good thing here.
> 
> Thanks !
> 
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 

Hi, Ingo

Do you have any objections against these patches?
[PATCH tip/tracing/markers] markers: simplify marker_set_format()
[PATCH tip/tracing/markers] markers: remove exported symbol marker_probe_cb_noarg()
[PATCH tip/tracing/markers] markers: let marker_table be close to its comments

My new patch are being made on the top of these patches.
new patch:
[PATCH tip/tracing/markers] markers: new callbacks manager
new patch remove a lot code and speed up critical region
and not change any APIs.

new patch change too much code, so I have to wait until all known
patches(which can be applied) have been applied.

Thanks, Lai




