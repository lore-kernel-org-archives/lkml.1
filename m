Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbZASBkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbZASBkg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 20:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbZASBk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 20:40:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58240 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755963AbZASBk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 20:40:26 -0500
Message-ID: <4973DA08.9050207@cn.fujitsu.com>
Date: Mon, 19 Jan 2009 09:40:24 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       miaox@cn.fujitsu.com, maxk@qualcomm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] cpuset: fix possible deadlock in	async_rebuild_sched_domains
References: <496FEFCA.9050908@cn.fujitsu.com> <4970000E.7040902@cn.fujitsu.com> <20090116125738.22c21bf2.akpm@linux-foundation.org> <4972E311.5010603@cn.fujitsu.com> <20090118090635.GB27144@elte.hu>
In-Reply-To: <20090118090635.GB27144@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> Can you measure any overhead from that? In any case, this is triggered on 
> admin activities (when reconfiguring cpusets), so it's a slowpath and thus 
> using existing infrastructure is preferred in the 99.9% of the cases. 
> 
>

I thought creating a thread waste some memory, the thread
is sleep at most time.

Thanks, Ingo.


Paul and Andrew:
Could you applied Miao's patch, this is a urgent bugfix.

Lai.

