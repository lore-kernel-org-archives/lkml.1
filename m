Return-Path: <linux-kernel-owner+w=401wt.eu-S1764772AbXGSSla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764772AbXGSSla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 14:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758292AbXGSSlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 14:41:22 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:38374 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032AbXGSSlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 14:41:21 -0400
Message-ID: <469FAFF7.6050801@googlemail.com>
Date: Thu, 19 Jul 2007 20:39:51 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Tejun Heo <htejun@gmail.com>, Avi Kivity <avi@qumranet.com>,
       =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>,
       Jens Axboe <axboe@suse.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       dri-devel@lists.sourceforge.net, Dave Airlie <airlied@linux.ie>,
       =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@tungstengraphics.com>,
       =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       Charles Gagalac <charles.gagalac@gmail.com>
Subject: Re: [1/2] 2.6.22-git: known regressions
References: <469F92A1.5070203@googlemail.com> <a781481a0707191005n6657251ah7ac4e078a4e628c1@mail.gmail.com> <469F9C3B.3040503@googlemail.com>
In-Reply-To: <469F9C3B.3040503@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
>>   
>>     
>>> Subject         : Oops while modprobing phy fixed module
>>> References      : http://lkml.org/lkml/2007/7/14/63
>>> Last known good : ?
>>> Submitter       : Gabriel C <nix.or.die@googlemail.com>
>>> Caused-By       : Tejun Heo <htejun@gmail.com>
>>>                   commit 3007e997de91ec59af39a3f9c91595b31ae6e08b
>>> Handled-By      : Satyam Sharma <satyam.sharma@gmail.com>
>>>                   Tejun Heo <htejun@gmail.com>
>>> Status          : unknown
>>>     
>>>       
>> This thread consisted of two unrelated/different oops stack traces :-)
>>
>> One of them was fixed by Tejun,
>> a1da4dfe35bc36c3bc9716d995c85b7983c38a76
>>
>> The other is SLUB related, I think.
>>
>>   
>>     
>
> Yes SLAB/SLUB traces.
>
> I will test the SLAB fix ( noone told me is fixed ) and I'll test the
> same with SLUB to see whatever is fixed in current git , later.
>
>
>   

Both looks fixed on current git head I cannot reproduce the Oops'es
anymore here.

Just the phy fixed driver is still broken.


Gabriel


