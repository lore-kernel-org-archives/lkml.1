Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab0CDBdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 20:33:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60022 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754993Ab0CDBdA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 20:33:00 -0500
Message-ID: <4B8F0DE9.1070907@cn.fujitsu.com>
Date: Thu, 04 Mar 2010 09:33:29 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.33: ftrace triggers soft lockup
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
In-Reply-To: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang wrote:
> Hi, Steven, Frederic, Ingo,
> 
> I am not sure if this is ftrace's fault, but it is ftrace who triggers
> the soft lockup. On my machine, it is pretty easy, just run:
> 
> echo function_graph > current_tracer
> 
> I found this when 2.6.33-rc7, but forgot to report here. I just tried today's
> Linus tree, it still has this problem.
> 

I can also trigger soft lockup while running a stress test for ftrace.

I'll post detailed information after more testing.

