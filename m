Return-Path: <linux-kernel-owner+w=401wt.eu-S1759134AbXGBLsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134AbXGBLsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 07:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbXGBLsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 07:48:14 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:11809 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbXGBLsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 07:48:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=A93A9GlpOlLGqeLb5Smp3h1OaBnZj+kIF+Dz0zsrtNj9EX+sp/n/zZRW6HLOn1s+JxMPrY1bImG8+SF0+X+j0UhgkyFh1IIC0tLchsiKAY4qcma9Si5Gog/34cKQzPrUoTRTzQiLA4owAmL7gAOdCmnaUVDiNBqZfvx2GYG+54s=
Message-ID: <863e9df20707020448o21c3baf2xda3528df312179c@mail.gmail.com>
Date: Mon, 2 Jul 2007 17:18:11 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: instrumentation and kprobes really still "EXPERIMENTAL"?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       systemtap@sources.redhat.com
In-Reply-To: <Pine.LNX.4.64.0707020619590.29879@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0707011204580.32355@localhost.localdomain>
	 <863e9df20707020154o5232e44ch37dd55811c377a8f@mail.gmail.com>
	 <Pine.LNX.4.64.0707020512320.26135@localhost.localdomain>
	 <863e9df20707020256m75d24f52yfc5acd78cacffac7@mail.gmail.com>
	 <Pine.LNX.4.64.0707020619590.29879@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> consider this random Kconfig file arch/x86_64/oprofile/Kconfig:
>
> =============================
> config PROFILING
>         bool "Profiling support (EXPERIMENTAL)"
>         help
>           Say Y here to enable the extended profiling support mechanisms used
>           by profilers such as OProfile.
>
>
> config OPROFILE
>         tristate "OProfile system profiling (EXPERIMENTAL)"
>         depends on PROFILING
>         help
>           OProfile is a profiling system capable of profiling the
>           whole system, include the kernel, kernel modules, libraries,
>           and applications.
>
>           If unsure, say N.
> ==============================
>
>   the above is a bit silly.  note that both prompts advertise
> themselves as "EXPERIMENTAL" even though neither of them has such a
> dependency.  they *are*, however, part of an submenu that *is*
> dependent on EXPERIMENTAL (although you'd never know that just by
> looking at that Kconfig file).  in short, it's just kind of ugly
> hackery at the moment.

Yes but pushing the EXPERIMENTAL check to individual menu members
shouldn't be done in a way which leads to an empty menu for any kernel
configuration. I suspect that this is why the EXPERIMENTAL check is on
the instrumentation menu in the first place.

>   my original point was simply that, based on its acceptance, it would
> seem kprobes has progressed beyond the EXPERIMENTAL phase, that's all.

It's worth a look on some archs.

--
Abhishek Sagar
-
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
