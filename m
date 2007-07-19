Return-Path: <linux-kernel-owner+w=401wt.eu-S940369AbXGSRRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940369AbXGSRRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938307AbXGSRRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:17:11 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:44602 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbXGSRRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:17:09 -0400
Message-ID: <469F9C3B.3040503@googlemail.com>
Date: Thu, 19 Jul 2007 19:15:39 +0200
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
References: <469F92A1.5070203@googlemail.com> <a781481a0707191005n6657251ah7ac4e078a4e628c1@mail.gmail.com>
In-Reply-To: <a781481a0707191005n6657251ah7ac4e078a4e628c1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On 7/19/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>
>   
>> Subject         : Section mismatch: reference to .init.data:cpu_llc_id (between 'set_cpu_sibling_map' and 'initialize_secondary')
>> References      : http://lkml.org/lkml/2007/7/19/202
>> Last known good : ?
>> Submitter       : Gabriel C <nix.or.die@googlemail.com>
>> Caused-By       : Jeremy Fitzhardinge <jeremy@xensource.com>
>>                   commit c70df74376c1e29a04e07e23dd3f4c384d6166dd
>> Handled-By      : ?
>> Status          : unknown
>>     
>
> Fixed by Jeremy Fitzhardinge, see:
>
> http://lkml.org/lkml/2007/7/18/410
>
> Dunno if it's in latest git.
>   

No is not.

>   
>> Subject         : Oops while modprobing phy fixed module
>> References      : http://lkml.org/lkml/2007/7/14/63
>> Last known good : ?
>> Submitter       : Gabriel C <nix.or.die@googlemail.com>
>> Caused-By       : Tejun Heo <htejun@gmail.com>
>>                   commit 3007e997de91ec59af39a3f9c91595b31ae6e08b
>> Handled-By      : Satyam Sharma <satyam.sharma@gmail.com>
>>                   Tejun Heo <htejun@gmail.com>
>> Status          : unknown
>>     
>
>
> This thread consisted of two unrelated/different oops stack traces :-)
>
> One of them was fixed by Tejun,
> a1da4dfe35bc36c3bc9716d995c85b7983c38a76
>
> The other is SLUB related, I think.
>
>   

Yes SLAB/SLUB traces.

I will test the SLAB fix ( noone told me is fixed ) and I'll test the
same with SLUB to see whatever is fixed in current git , later.

>> Block layer
>>
>> Subject         : broken {sd,hd}parm
>> References      : http://lkml.org/lkml/2007/7/16/389
>> Last known good : ?
>> Submitter       : Gabriel C <nix.or.die@googlemail.com>
>> Caused-By       : ?
>> Handled-By      : FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>> Status          : problem is being debugged
>>     
>
> James Bottomley posted a patch for it just now, Gabriel seems
> to be happy with it
>
>   


Yes :)

http://lkml.org/lkml/diff/2007/7/19/357/1

Everything works again with this patch.


Gabriel

