Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbZGHEnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbZGHEnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 00:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbZGHEnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 00:43:42 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:43369 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZGHEnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 00:43:42 -0400
Message-ID: <4A5423F9.3010102@davidnewall.com>
Date: Wed, 08 Jul 2009 14:13:37 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Changli Gao <xiaosuo@gmail.com>
CC: Zan Lynx <zlynx@acm.org>, Denys Vlasenko <vda.linux@googlemail.com>,
       Albert ARIBAUD <albert.aribaud@free.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
References: <20090703015554.GB5880@cr0.nay.redhat.com>	 <412e6f7f0907030259m5556ee2fobbb58d377bce4d17@mail.gmail.com>	 <4A4DDD54.9030206@free.fr>	 <200907070643.56394.vda.linux@googlemail.com>	 <412e6f7f0907070045o6a17fb10x557108ffde0da11@mail.gmail.com>	 <4A53B202.9080505@davidnewall.com> <4A53B7DB.5050105@acm.org> <412e6f7f0907072141x6de32dddj139c7bc1435d3bf6@mail.gmail.com>
In-Reply-To: <412e6f7f0907072141x6de32dddj139c7bc1435d3bf6@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changli Gao wrote:
> On Wed, Jul 8, 2009 at 5:02 AM, Zan Lynx<zlynx@acm.org> wrote:
>   
>> But perhaps mkfifo(NULL) should be the syscall chosen to extend since its
>> parameters are much like open() already, and it seems to work in the above
>> sequence to create a one-FD FIFO already.
>>
>>     
> It sounds a good idea.
>   

I disagree.  I disbelieve that the cost of two fds per pipe is too high.
