Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbZD3BLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbZD3BLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 21:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbZD3BLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 21:11:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57290 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbZD3BLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 21:11:14 -0400
Message-ID: <B0DFF0EA5CE64F6683BEDD6641CA20C2@zhaoleiwin>
From: "Zhaolei" <zhaolei@cn.fujitsu.com>
To: "Frederic Weisbecker" <fweisbec@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Tom Zanussi" <tzanussi@gmail.com>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Oleg Nesterov" <oleg@redhat.com>,
       "LKML" <linux-kernel@vger.kernel.org>
References: <49F6DFB5.2040901@cn.fujitsu.com> <20090429000616.f7e72b73.akpm@linux-foundation.org> <20090429133342.GA5987@nowhere>
Subject: Re: [PATCH 0/4] workqueue_trace: Add max execution time mesurementfor per worklet
Date: Thu, 30 Apr 2009 09:10:26 +0800
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n3U1BWqu022731

* From: "Frederic Weisbecker" <fweisbec@gmail.com>
> On Wed, Apr 29, 2009 at 12:06:16AM -0700, Andrew Morton wrote:
>> What is the meaning of M_EXECus?  Mean execution time in microseconds,
>> I assume?  I wonder if that is sufficiently high resolution nowadays.
> 
> 
> It's the maximum execution time encountered for a given worklet.
> I also have a small patch, about ready, to get the average.
> 
> 
>> You'll note that all the functions are reported as "foo+0x0/0xN". 
>> There is a way of suppressing the unneeded and unuseful "+0x0/0xN",
>> but I forget what it is and the comments over lib/vsprintf.c:pointer()
>> didn't help.  I think it's %pS.
> 
> 
> I don't know any way to perform this.
> %pF and %pS will act pretty much the same, except:
> 
> Extract from lib/vsprintf.c:
> 
> * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
> * function pointers are really function descriptors, which contain a
> * pointer to the real address.
> 
> But the output formatting is the same: address, offset, size, modname.
> 
> I found it a bit annoying, so I proposed the following patch recently:
> 
> http://lkml.org/lkml/2009/4/15/310
> 
> And someone came with a better idea, IMO:
> 
> http://lkml.org/lkml/2009/4/17/105
> 
> 
>> 
>> The patchset adds no user documentation for the feature and should not
>> (IMO) be merged in such a state.  Please.
>>
> 
> 
> Ok, I will try something today about the documentation.
> 
> Thanks!
Hello,

To Frederic
Thanks for reply this mail for me.
Your saying is better than me.

To Andrew:
Sorry for replay late, I was rest yesterday.
Frederic's answer is all I wish to say.

Thanks
Zhaolei


> 
> 
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
