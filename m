Return-Path: <linux-kernel-owner+w=401wt.eu-S1756845AbZEVIuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbZEVIuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbZEVIuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:50:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51861 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbZEVIup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:50:45 -0400
Message-ID: <C81DF133055643E0A5EB3403B72ED073@zhaoleiwin>
From: "Zhaolei" <zhaolei@cn.fujitsu.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>
Cc: "Frederic Weisbecker" <fweisbec@gmail.com>,
       "Tom Zanussi" <tzanussi@gmail.com>,
       "LKML" <linux-kernel@vger.kernel.org>
References: <4A14FDFE.2080402@cn.fujitsu.com> <alpine.DEB.2.00.0905210915080.4632@gandalf.stny.rr.com> <20090522080144.GB11438@elte.hu> <20090522082531.GA5993@elte.hu>
Subject: Re: [PATCH 1/2] ftrace: Add task_comm support for trace_event
Date: Fri, 22 May 2009 16:49:18 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n4M8p0lL032766

* From: "Ingo Molnar" <mingo@elte.hu>
> 
> note, this patch fails -tip testing:
> 
> kernel/built-in.o: In function `ftrace_event_enable_disable':
> trace_events.c:(.text+0x6cf7a): undefined reference to `tracing_stop_cmdline_record'
> trace_events.c:(.text+0x6cf91): undefined reference to `tracing_start_cmdline_record'

Hello, Ingo

Sorry for this bug.

Maybe it is caused by not config sched_switch tracer.
trace_sched_switch.c is necessary for trace_event.c now.
I'll test and fix it.

Thanks
Zhaolei

> 
> Ingo
> 
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
