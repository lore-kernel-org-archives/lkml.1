Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbZEJGTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbZEJGTM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 02:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbZEJGS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 02:18:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53717 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbZEJGS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 02:18:57 -0400
Message-ID: <4A067200.2020603@cn.fujitsu.com>
Date: Sun, 10 May 2009 14:19:44 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] tracing: initialize return value for __ftrace_set_clr_event
References: <20090508203605.361898511@goodmis.org> <20090508203827.665792546@goodmis.org>
In-Reply-To: <20090508203827.665792546@goodmis.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -118,7 +118,7 @@ static int __ftrace_set_clr_event(const char *match, const char *sub,
>  				  const char *event, int set)
>  {
>  	struct ftrace_event_call *call;
> -	int ret;
> +	int ret = -EINVAL;
>  

Thanks! Seems gcc is not good enough to warn on this
may-be-used-uninitialized..

--
Zefan

