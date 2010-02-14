Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab0BNUHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 15:07:49 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:53656 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab0BNUHr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 15:07:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GWtRaoYu1Ph5HIJcp87Vd5g9iidzdyPfNm1+vyx4MdGfzMCqJ2Te2BJZ5ZuAa+zBQt
         aLm8hTL1s/WgjrsWVatV4WVMW4Z5yewNBVgB7F7fpPh0oNqF48+OhaWrh5dGMHO1LS76
         rqyOrPjtVg8tksE0uBKZJ1lX+7667yUbpEYc8=
MIME-Version: 1.0
In-Reply-To: <20100214193406.GA15722@khazad-dum.debian.net>
References: <201002140251.59668.volkerarmin@googlemail.com>
	 <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
	 <20100214193406.GA15722@khazad-dum.debian.net>
Date: Sun, 14 Feb 2010 12:07:45 -0800
Message-ID: <4877c76c1002141207s7bac4275xd12ed75e46a670c4@mail.gmail.com>
Subject: Re: Linux mdadm superblock question.
From: Michael Evans <mjevans1983@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Volker Armin Hemmann <volkerarmin@googlemail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 11:34 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Sat, 13 Feb 2010, Michael Evans wrote:
>> I remember hearing that 1.x had /no/ plans for kernel level
>> auto-detection ever.  That can be accomplished in early-userspace
>> leaving the code in the kernel much less complex, and therefore far
>> more reliable.
>
> Yes, it is far more reliable kernel side, if only because it doesn't do
> anything.
>
> But the userspace reliability is _not_ good.  initrds are a source of
> problems the moment things start to go wrong, and that's when they are not
> the problem themselves.
>
> And the end result is a system that needs manual intervention to get its
> root filesystem back.
>
> In my experience, every time we moved critical codepaths to userspace, we
> ended up decreasing the *overall* system reliability.
>
> --
>  "One disk to rule them all, One disk to find them. One disk to bring
>  them all and in the darkness grind them. In the Land of Redmond
>  where the shadows lie." -- The Silicon Valley Tarot
>  Henrique Holschuh
>

Maybe you'd like a simple, easy to customize initramfs creator.
That's exactly what I was aiming for when I made AEUIO
https://sourceforge.net/projects/aeuio  There are some things that
could use improvement, but if your system can boot without loading
modules it should be more than sufficient even across kernel versions.
