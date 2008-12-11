Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbYLKFCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbYLKFCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 00:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbYLKFCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 00:02:13 -0500
Received: from smtp.zeuux.org ([210.51.160.52]:55187 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbYLKFCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 00:02:13 -0500
Date: Thu, 11 Dec 2008 13:02:06 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: Nguyen Anh Quynh <aquynh@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Kuniyasu Suzaki <k.suzaki@aist.go.jp>
Subject: Re: [PATCH] fix calls to request_module()
Message-ID: <20081211050206.GB7266@ubuntu>
References: <9cde8bff0812101935j5ef56140k67035d892a868738@mail.gmail.com> <20081211040118.GK28946@ZenIV.linux.org.uk> <20081210201455.0c611484.akpm@linux-foundation.org> <9cde8bff0812102023v60ce265bk394c420a29100b92@mail.gmail.com> <20081211044017.GA7266@ubuntu> <9cde8bff0812102043w43ee18b5y7f3ed50b99736891@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cde8bff0812102043w43ee18b5y7f3ed50b99736891@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nguyen Anh Quynh wrote:

>On Thu, Dec 11, 2008 at 1:40 PM, Jianjun Kong <jianjun@zeuux.org> wrote:
>> * Nguyen Anh Quynh wrote:
>>>>> > The request_module() function should always have the 1st param as a
>>>>> > format argument. So for example, request_module("i2c-powermac") should
>>>>> > be called as request_module("%s", "i2c-powermac"). Otherwise, new gcc
>>>>> > like gcc 4.3.2 on Ubuntu 8.10 would spit out a lot of warnings. This
>>>>> > patch fixes them all in linus-git tree.

<sign>
>> Hi,all
>> I also use Ubuntu 8.10, gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu11)
>>
>> When I compile the latest kernel, there are more warning. Like this:

<sign>
>> arch/x86/kernel/e820.c: In function 'early_panic':
>> arch/x86/kernel/e820.c:1172: warning: format not a string literal and no format arguments
>> arch/x86/kernel/e820.c:1173: warning: format not a string literal and no format arguments
>> kernel/power/main.c: In function 'test_suspend':
>> kernel/power/main.c:720: warning: format not a string literal and no format arguments
>> fs/dquot.c: In function 'find_quota_format':
>> fs/dquot.c:170: warning: format not a string literal and no format arguments
>> crypto/api.c: In function 'crypto_larval_lookup':
>> crypto/api.c:218: warning: format not a string literal and no format arguments
>> crypto/algapi.c: In function 'crypto_lookup_template':
>> crypto/algapi.c:427: warning: format not a string literal and no format arguments
>> ...
>
>I saw the same thing. My patch only fixed part of them.
>
>So please submit your patch to fix the remainig :-)

But there is no this kind of warns at Fedora 10, gcc version 4.3.2 20081105 (Red Hat 4.3.2-7)

We should make clean whether your patch is correct first. 
There are many more that kind of warns. I just list little of them.


	Jianjun
-- 
Jianjun Kong |Happy Hacking
Homepage: http://kongove.cn
Gtalk:KongJianjun@gmail.com
