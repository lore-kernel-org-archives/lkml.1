Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbZKJUui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbZKJUui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758074AbZKJUuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:50:37 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:63590 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbZKJUug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:50:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=GueRjRJR3yeS33qsOFlocSm6xyj5/291yzcT6QbSvegFuz5eDA4+QFnUOOWZsfQwsv
         HB4azIbHQ9EZWdJoVX8PQbz0+ynkV1Y6xqk3V2LjxwLgrlAw0+EId7hurwuvcKHypoWN
         E6n/+qXv3O9r248rJWw/F7xicW4/UvBK0y1Dk=
MIME-Version: 1.0
In-Reply-To: <43e72e890911101230t23933eaem4d7bc10237e1a725@mail.gmail.com>
References: <43e72e890911041540hd1e5f87u8d282d9c95857504@mail.gmail.com> 
	<alpine.LFD.2.01.0911041551220.31845@localhost.localdomain> 
	<20091105071431.GA14055@elte.hu> <43e72e890911081135q78416ef7ua6c5991b15fb2659@mail.gmail.com> 
	<20091109071558.GC453@elte.hu> <43e72e890911090749r5b35fb83s4991bb9c44a1773a@mail.gmail.com> 
	<43e72e890911101230t23933eaem4d7bc10237e1a725@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 10 Nov 2009 12:50:21 -0800
Message-ID: <43e72e890911101250tcc8dcdk7a639bdbe7b00215@mail.gmail.com>
Subject: Re: Reverting 5d423 fixes loading of ath9k on Acer Extensa 7630EZ
To: Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>,
       stable@kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Yannick Roehlly <yannick.roehlly@free.fr>,
       Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jesse.barnes@intel.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       "John W. Linville" <linville@tuxdriver.com>, berndl81@gmx.at,
       Ingo Molnar <mingo@elte.hu>, Stefan Bader <stefan.bader@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 12:30 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Mon, Nov 9, 2009 at 7:49 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Sun, Nov 8, 2009 at 11:15 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>>
>>> * Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>>
>>>> On Wed, Nov 4, 2009 at 11:14 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>>> >
>>>> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>>> >
>>>> >> On Wed, 4 Nov 2009, Luis R. Rodriguez wrote:
>>>> >> >
>>>> >> > Can you please consider reviewing this issue and help determine if
>>>> >> > this indeed needs to be reverted for 2.6.32 and the next 2.6.31.y.
>>>> >> >
>>>> >> > I am curious if other devices would work by reverting this as well.
>>>> >> > [ ... ] For details please feel free to check:
>>>> >> >
>>>> >> > http://bugzilla.kernel.org/show_bug.cgi?id=14402
>>>> >>
>>>> >> That same commit was the cause for
>>>> >>
>>>> >> ?? ?? ?? http://bugzilla.kernel.org/show_bug.cgi?id=13940
>>>> >>
>>>> >> and we just increased the rounding to make it go away (see commit
>>>> >> 15b812f1). But that was a hack.
>>>> >>
>>>> >> And if that didn't help the ath9k case, then we should just revert
>>>> >> entirely.
>>>> >
>>>> > Agreed - below is the combo 15b812f1 + 5d423ccd revert. (Would be nice
>>>> > to get the boot log of the latest post-15b812f1 kernel that Yinghai
>>>> > asked for before we revert, in the hope of better understanding the
>>>> > problem.)
>>>>
>>>> Bernhard has confirmed the new patch fixes this issue.
>>>
>>> Good - so latest kernels should be fine (on Bernhard's box) and no
>>> change is needed, right?
>>
>> Yea, but it does mean we need a fix propagated down to older kernels.
>
> Greg, please consider applying 15b812f1d0 to stable 2.6.31 as it fixes
> an issue introduced on 2.6.31 and only fixed now for 2.6.32. This
> should fix an issue when loading either sky2 or ath9k on some specific
> platforms.
>
> The details for the ath9k debugging are available on this bug:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=14402

Just noticed this did make it to 2.6.31.6, sorry for the noise and thanks.

  Luis
