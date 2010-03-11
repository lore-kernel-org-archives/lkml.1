Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab0CKKtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 05:49:39 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45580 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab0CKKti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 05:49:38 -0500
Message-ID: <4B98CAC0.5030009@cs.helsinki.fi>
Date: Thu, 11 Mar 2010 12:49:36 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "=?UTF-8?B?QW3DqXJpY28gV2FuZw==?=" <xiyou.wangcong@gmail.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       roland@redhat.com, peterz@infradead.org
Subject: Re: 2.6.34-rc1: kernel BUG at mm/slab.c:2989!
References: <2375c9f91003100029q7d64bbf7xce15eee97f7e2190@mail.gmail.com>	 <4B977282.40505@cs.helsinki.fi>	 <alpine.DEB.2.00.1003100832200.17615@router.home>	 <2375c9f91003101842g713bba07v146a53f12a15a8d7@mail.gmail.com> <2375c9f91003110157y35d26e39odcd8efd9b44d83a1@mail.gmail.com>
In-Reply-To: <2375c9f91003110157y35d26e39odcd8efd9b44d83a1@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang kirjoitti:
> On Thu, Mar 11, 2010 at 10:42 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> On Wed, Mar 10, 2010 at 10:33 PM, Christoph Lameter
>> <cl@linux-foundation.org> wrote:
>>> On Wed, 10 Mar 2010, Pekka Enberg wrote:
>>>
>>>>> Please let me know if you need more info.
>>>> Looks like regular SLAB corruption bug to me. Can you trigget it with SLUB?
>>> Run SLUB with CONFIG_SLUB_DEBUG_ON or specify slub_debug on the kernel
>>> command line to have all allocations checked.
>>>
>>>
>> Ok, I will try it today.
> 
> Sorry, I can't trigger it today, either with SLAB or SLUB.

Is it the exact same version or is it a new git snapshot?
