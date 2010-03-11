Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab0CKJ54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 04:57:56 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:43112 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab0CKJ5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:57:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AHaqdVPQJDFx219s2JWNHN6UniIrZhqwn/iIfchU7i9GSZNTtwArPfydTOMfvjPh18
         Vh+zFW6uBtHYNHS95JNaXuZPITOs2jvYoQ1RlkA8HMbyrvD6d6KX3lpta6EVNlulJqQm
         PIR4iKfx8VngVdEggMkYCmoXiI6//QVOGmtBU=
MIME-Version: 1.0
In-Reply-To: <2375c9f91003101842g713bba07v146a53f12a15a8d7@mail.gmail.com>
References: <2375c9f91003100029q7d64bbf7xce15eee97f7e2190@mail.gmail.com>
	 <4B977282.40505@cs.helsinki.fi>
	 <alpine.DEB.2.00.1003100832200.17615@router.home>
	 <2375c9f91003101842g713bba07v146a53f12a15a8d7@mail.gmail.com>
Date: Thu, 11 Mar 2010 17:57:54 +0800
Message-ID: <2375c9f91003110157y35d26e39odcd8efd9b44d83a1@mail.gmail.com>
Subject: Re: 2.6.34-rc1: kernel BUG at mm/slab.c:2989!
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       roland@redhat.com, peterz@infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 10:42 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Wed, Mar 10, 2010 at 10:33 PM, Christoph Lameter
> <cl@linux-foundation.org> wrote:
>> On Wed, 10 Mar 2010, Pekka Enberg wrote:
>>
>>> > Please let me know if you need more info.
>>>
>>> Looks like regular SLAB corruption bug to me. Can you trigget it with SLUB?
>>
>> Run SLUB with CONFIG_SLUB_DEBUG_ON or specify slub_debug on the kernel
>> command line to have all allocations checked.
>>
>>
>
> Ok, I will try it today.
>

Sorry, I can't trigger it today, either with SLAB or SLUB.
