Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbZINJAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbZINJAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 05:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbZINJAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 05:00:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51544 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755129AbZINJAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 05:00:09 -0400
Message-ID: <4AAE05CF.5060208@cn.fujitsu.com>
Date: Mon, 14 Sep 2009 16:58:55 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ftrace: Add compile-time check on F_printk()
References: <4AADF60B.5070407@cn.fujitsu.com> <4AADF6CC.1060809@cn.fujitsu.com>
In-Reply-To: <4AADF6CC.1060809@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static void __used ____ftrace_check_##name(void)		\

oops, I should use "__maybe_unused"..

> +{								\
> +	struct ____ftrace_##name *__entry = NULL;		\
> +								\
> +	/* force cmpile-time check on F_printk() */		\
> +	printk(print);						\
> +}
