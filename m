Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188Ab0CKQP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 11:15:56 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45094 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136Ab0CKQPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 11:15:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=bA46TkuifZ2BP9IlCgp12odDdFwuotUo2OLkvdzUGOSAQN/rckUFNaPW+1DWOV1mR4
         CHheA6JEggNZnk3nsfFC8FvR50aqC8WCQCjBuKe3fBVAJa8cHbcFQjyttC+/ZXP1jprw
         vJas9YwjZi2r1xUmA2NWH7kGhs/IBk/gFl6sQ=
Date: Fri, 12 Mar 2010 00:19:05 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       roland@redhat.com, peterz@infradead.org
Subject: Re: 2.6.34-rc1: kernel BUG at mm/slab.c:2989!
Message-ID: <20100311161905.GB3804@hack>
References: <2375c9f91003100029q7d64bbf7xce15eee97f7e2190@mail.gmail.com> <4B977282.40505@cs.helsinki.fi> <alpine.DEB.2.00.1003100832200.17615@router.home> <2375c9f91003101842g713bba07v146a53f12a15a8d7@mail.gmail.com> <2375c9f91003110157y35d26e39odcd8efd9b44d83a1@mail.gmail.com> <4B98CAC0.5030009@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B98CAC0.5030009@cs.helsinki.fi>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 12:49:36PM +0200, Pekka Enberg wrote:
> Américo Wang kirjoitti:
>> On Thu, Mar 11, 2010 at 10:42 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>>> On Wed, Mar 10, 2010 at 10:33 PM, Christoph Lameter
>>> <cl@linux-foundation.org> wrote:
>>>> On Wed, 10 Mar 2010, Pekka Enberg wrote:
>>>>
>>>>>> Please let me know if you need more info.
>>>>> Looks like regular SLAB corruption bug to me. Can you trigget it with SLUB?
>>>> Run SLUB with CONFIG_SLUB_DEBUG_ON or specify slub_debug on the kernel
>>>> command line to have all allocations checked.
>>>>
>>>>
>>> Ok, I will try it today.
>>
>> Sorry, I can't trigger it today, either with SLAB or SLUB.
>
> Is it the exact same version or is it a new git snapshot?

No, I did a git pull, but it looks like only some btrfs updates...

