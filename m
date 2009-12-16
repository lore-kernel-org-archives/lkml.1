Return-Path: <linux-kernel-owner+w=401wt.eu-S1761343AbZLPKbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761343AbZLPKbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761287AbZLPKbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:31:42 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:45354 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761277AbZLPKbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:31:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hD/FMJxcPyRKp6iHINLK9DjlZIZeXnNbDxuUCfQzeoodQZ7AQn32PM1e2sJkLZvoNM
         chmNENeW0yRQg29kzsUUDw9xGUoVptbs9n/Ni6YeZyQf96ilgahprnTwAd8Lr303b1Fv
         8MhRsy6LzyZdBVJfQafvzRlGvYXgacNQms3T4=
MIME-Version: 1.0
In-Reply-To: <20091216102806.GC15031@basil.fritz.box>
References: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com>
	 <20091216101107.GA15031@basil.fritz.box>
	 <20091216191312.f4655dac.kamezawa.hiroyu@jp.fujitsu.com>
	 <20091216102806.GC15031@basil.fritz.box>
Date: Wed, 16 Dec 2009 19:31:40 +0900
Message-ID: <28c262360912160231r18db8478sf41349362360cab8@mail.gmail.com>
Subject: Re: [mm][RFC][PATCH 0/11] mm accessor updates.
From: Minchan Kim <minchan.kim@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 7:28 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> > Also the patches didn't fare too well in testing unfortunately.
>> >
>> > I suspect we'll rather need multiple locks split per address
>> > space range.
>>
>> This set doesn't include any changes of the logic. Just replace all mmap_sem.
>> I think this is good start point (for introducing another logic etc..)
>
> The problem is that for range locking simple wrapping the locks
> in macros is not enough. You need more changes.

I agree.

We can't justify to merge as only this patch series although this
doesn't change
any behavior.

After we see the further works, let us discuss this patch's value.

Nitpick:
In case of big patch series, it would be better to provide separate
all-at-once patch
with convenience for easy patch and testing. :)

Thanks for great effort. Kame.

>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only.
>



-- 
Kind regards,
Minchan Kim
