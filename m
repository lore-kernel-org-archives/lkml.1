Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbZK0VVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbZK0VVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 16:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbZK0VVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 16:21:09 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40543 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbZK0VVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 16:21:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BejgenjbUafxUScf+9YWNbqLFbHd7tQysmjb0eRw7+QScTAOPxL/Ooq2KqirL+5Tiw
         fqIqLre9Y7gPSbku+8Wjv87AiaBgjhhvghQPKkPqvqNUxIp0/V4k5B1zwtSKxonU2bfc
         B9kYUfWqXp0OCOE+OVTWkmranN0fhsepDha74=
MIME-Version: 1.0
In-Reply-To: <4B0FB6CA.1030509@snapgear.com>
References: <20091126115806.c53684f5.sfr@canb.auug.org.au>
	 <10f740e80911261329s35f62au37e6b209c657e09@mail.gmail.com>
	 <4B0F5908.3090900@snapgear.com>
	 <10f740e80911270043h567f6bf3l9fc51cfe5a6ac0af@mail.gmail.com>
	 <4B0FB6CA.1030509@snapgear.com>
Date: Fri, 27 Nov 2009 22:21:12 +0100
X-Google-Sender-Auth: 614f12b76f844609
Message-ID: <10f740e80911271321t305e6439kc49707ac47d41a63@mail.gmail.com>
Subject: Re: linux-next: manual merge of the m68knommu tree with the m68k tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andreas Schwab <schwab@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 12:23, Greg Ungerer <gerg@snapgear.com> wrote:
> On 11/27/2009 06:43 PM, Geert Uytterhoeven wrote:
>> On Fri, Nov 27, 2009 at 05:43, Greg Ungerer<gerg@snapgear.com>  wrote:
>>> Geert Uytterhoeven wrote:
>>>> On Thu, Nov 26, 2009 at 01:58, Stephen Rothwell<sfr@canb.auug.org.au>
>>>> wrote:
>>>>>
>>>>> Today's linux-next merge of the m68knommu tree got a conflict in
>>>>> arch/m68k/include/asm/ptrace.h between commit
>>>>> 63c361b65f6540043c4baabf1a044a45c7465858 ("m68k: use generic code for
>>>>> ptrace requests") from the m68k tree and commit
>>>>> 03a03164e8084b810e9f92906a51232d63bac72c ("m68knommu: define
>>>>> arch_has_single_step() and friends") from the m68knommu tree.
>>>>>
>>>>> These mostly add the same stuff but not quite :-(
>>>>
>>>> Ah sorry, my bad. I'm not yet used to the uClinux guys touching "my"
>>>> includes ;-)
>>>> So we need better coordination between us.
>>>>
>>>> IIRC, Greg's changes were inspired by Andreas' patch.
>>>
>>> Yes, largely they are.
>>>
>>>
>>>>> I have done a fixup (see below) and can carry it as necessary.  Please
>>>>> check the result.
>>>>
>>>> At first sight, it looks OK. Thanks for fixing it up!
>>>
>>> Yep, looks ok from what I can see.
>>>
>>> Geert, how do you want to handle for the real linus merge?
>>> Do you want me to drop the changes to ptrace.h from that patch?
>>
>> I can apply your patch (modified to apply on top of Andreas') to the
>> m68k for-linus branch.
>> Does that sound OK for you?
>
> Yep, thats fine by me.

Done.

I also added the #ifdef CONFIG_MMU to Andreas' commit, so it will stay
bisectable on m68knommu.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
