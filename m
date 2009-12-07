Return-Path: <linux-kernel-owner+w=401wt.eu-S934660AbZLGEzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934660AbZLGEzv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 23:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934641AbZLGEzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 23:55:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49172 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934635AbZLGEzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 23:55:48 -0500
Message-ID: <4B1C8A74.9000700@cn.fujitsu.com>
Date: Mon, 07 Dec 2009 12:54:12 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] perf_event: fix for procing raw event
References: <4B1C7EE1.8030906@cn.fujitsu.com> <4B1C7F45.5080105@cn.fujitsu.com>
In-Reply-To: <4B1C7F45.5080105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Xiao Guangrong wrote:
> We use 'data.raw_data' parameter to call process_raw_event(), but
> data.raw_data buffer not include data size. it can make perf tool
> crash.
> 

It seems raw->size is not use, I'll send a patch to cleanup it.
