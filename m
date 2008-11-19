Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbYKSH1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbYKSH1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 02:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbYKSH1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 02:27:21 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:57094 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbYKSH1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 02:27:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=WAJ+fN7UjgHZmc72NK5fs3DOuIAbTZR4rcZUE2TSInpQe7na1mro3US7HfgB88TPw9
         3ep5R43CPwuyrRltIe0c3fLgd6TgryiqiyiTudhC0DKQ5jg3I372qkuJXxGPa6qUlpHP
         28+0OYsqsMeUoSseMBqVRxsnDsLT082J0s0UU=
Message-ID: <386072610811182327x72df4615od53679b19cf49ed0@mail.gmail.com>
Date: Wed, 19 Nov 2008 15:27:19 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/5] Blackfin SMP like patchset
Cc: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20081118225621.540416ae.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226999108-13839-1-git-send-email-cooloney@kernel.org>
	 <20081118225621.540416ae.akpm@linux-foundation.org>
X-Google-Sender-Auth: a295dbd8bae35066
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 2:56 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 18 Nov 2008 17:05:03 +0800 Bryan Wu <cooloney@kernel.org> wrote:
>
>>
>> Hi folks,
>>
>> We provide the SMP like functions for our Blackfin dual core processor
>> BF561 for almost 1 year. And after a long time developing, debugging and
>> internal review, we'd like to post them to LKML for other maintainer
>> review.
>>
>> Please find our wiki page about this SMP like patches:
>> http://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:smp-like
>
> Would prefer that changelogs be self-contained, please.  Kernel
> changelogs are for ever, and I doubt if that page will be there in 20
> years time.
>

I guess Graf started this wiki recently although the patch exists for
a long time.
And Graf gave a presentation about this SMP on BF561 in AKA 2008 Linux kernel
developer conference. If I found the link of this presentation, I will
post it again.

> Particularly when that page must be read to learn fundamental things such as
>
>  The SMP support in certain Blackfin processors is describe as `SMP
>  Like' rather than just `SMP' due to the lack of hardware cache
>  coherency.  A true SMP system would have support for cache coherency
>  in hardware.
>
>  On all `SMP Like' setups, cache coherency is maintained via
>  software mechanisms
>
> Interesting!
>

Exactly, SMP means hardware cache coherency. But BF561 dual core
processor was designed almost 8 years ago.
we have to do some workaround in software side. Fortunately, BF561
provides a L2 memory shared by both CoreA and CoreB.
We did some trick in this L2 memory and our Scratchpad memory.

'SMP Like' is software aided SMP solution on Blackfin dual core BF561 processor.
Please enjoy -:)

-Bryan
