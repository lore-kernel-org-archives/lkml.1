Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbZDMEH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbZDMEH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 00:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbZDMEHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 00:07:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54007 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbZDMEHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 00:07:48 -0400
Message-ID: <7D90907194A540339DD93446AFE09B37@zhaoleiwin>
From: "Zhaolei" <zhaolei@cn.fujitsu.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Frederic Weisbecker" <fweisbec@gmail.com>,
       "Tom Zanussi" <tzanussi@gmail.com>, <linux-kernel@vger.kernel.org>
References: <49E28D4B.5040802@cn.fujitsu.com> <20090413103639.6DF4.A69D9226@jp.fujitsu.com> <20090413122350.6DFE.A69D9226@jp.fujitsu.com> <49E2B656.1020308@cn.fujitsu.com> <20090413035700.GE11652@elte.hu>
Subject: Re: Re: [PATCH 1/1] tracing, workqueuetrace: Make workqueuetracepoints use TRACE_EVENT macro
Date: Mon, 13 Apr 2009 12:07:28 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n3D480qu025052

* From: "Ingo Molnar" <mingo@elte.hu>
> 
> * Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> 
>> It it because I use similar format with other TRACE_EVENT 
>> definition. Actually, I don't know why we need to add prefix and 
>> postfix TABs, and is it necessary to use tab to make alignment for 
>> each fields.
> 
> The __array() entry is a bit special - i wouldnt worry much about 
> it, please ignore the checkpatch warning in this case - or remove 
> the prefix tab.
Hello, Ingo 

Thanks for your teach.

I think remove the prefix tab only(but remain postfix) make code looks
a bit ugly. I prefer to remain both tabs.
It is to say I will not modify tabs in this patch.

Thanks
Zhaolei

> 
> The alignment of the fields are useful visually: all the field names 
> are enumerated in a vertical row and are easy to see at a glance. 
> The postfix tabs are nice because they move the non-C-syntax closing 
> ')' out of the line of sight. The prefix tabs are useful for a 
> similar reason.
> 
> Ingo
> 
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
