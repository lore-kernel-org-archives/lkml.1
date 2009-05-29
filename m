Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbZE2A5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbZE2A5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 20:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZE2A5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 20:57:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61814 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbZE2A5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 20:57:13 -0400
Message-ID: <31D61E75D41F40578C8AFC0B0C6FCA11@zhaoleiwin>
From: "Zhaolei" <zhaolei@cn.fujitsu.com>
To: "Frederic Weisbecker" <fweisbec@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
Cc: "Xiao Guangrong" <xiaoguangrong@cn.fujitsu.com>,
       "Anton Blanchard" <anton@samba.org>, <rostedt@goodmis.org>,
       <mingo@elte.hu>, <tzanussi@gmail.com>, <jbaron@redhat.com>,
       <kosaki.motohiro@jp.fujitsu.com>, <linux-kernel@vger.kernel.org>
References: <20090520101334.GA23442@kryten> <20090526042643.GB19728@kryten> <20090526180600.GA5969@nowhere> <4A1D07C8.6010002@cn.fujitsu.com> <alpine.LFD.2.00.0905271619360.3397@localhost.localdomain> <20090527144822.GC5982@nowhere>
Subject: Re: [PATCH] tracing/events: Add timer and high res timertracepoints
Date: Fri, 29 May 2009 08:55:31 +0800
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n4T0vR7M013836

* From: "Frederic Weisbecker" <fweisbec@gmail.com>
> On Wed, May 27, 2009 at 04:22:28PM +0200, Thomas Gleixner wrote:
>> On Wed, 27 May 2009, Xiao Guangrong wrote:
>> > In fact, Anton Blanchard's is different from my patch.
>> > My patch is used for trace timer lifecycle(init/start/expire/cancel), and his
>> > patch is mostly used for trace the execution time of timer function.
>> 
>> Right, but they should be combined into one set.
> 
> 
> Ok.
> 
> 
>> Frederic, can you please pick up Anton's patch right away so Xiao can
>> work on top of it and add the init/start/cancel instrumentation.
>> 
>> Thanks,
>> 
>> tglx
> 
> 
> Sure. I've applied it on
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/timer
> 
> Xiao can work on top of it.
> This is a branch made against tip:/tracing/core

Hello, Frederic

We'll rebase our patch on it.

Thanks
Zhaolei

> 
> Frederic.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
