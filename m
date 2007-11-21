Return-Path: <linux-kernel-owner+w=401wt.eu-S1760353AbXKUIul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353AbXKUIul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 03:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbXKUIud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 03:50:33 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:34897 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703AbXKUIuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 03:50:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eCyqRgR4MQ1QRlgcJVf4OVsNyIg3wfFqvv4PVsfJGzOr4AuYmEZ6PfRd22vRmTBc9bwt4eGgPQE6ejfWx/AYPa2Z8j0SMMSv4PyaYjerj2GuZnJQnskczL0piosd9stm3Zl84B5FNO1TWZSlZZ7zuglKu3WlfX2ilQA1OtN1cPQ=
Message-ID: <b637ec0b0711210050x1fbd741bi9c7550b4ef611598@mail.gmail.com>
Date: Wed, 21 Nov 2007 09:50:31 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3, v2.6.23.8, v2.6.22.13, v2.6.21.7
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071120215313.GD24156@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071119151756.GA25446@elte.hu>
	 <b637ec0b0711201238i746ca9bala3812ca93479c6fa@mail.gmail.com>
	 <20071120204103.GC10008@elte.hu>
	 <b637ec0b0711201247m4038a2cds5924ddbd43db6f8e@mail.gmail.com>
	 <20071120215313.GD24156@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Nov 20, 2007 10:53 PM, Ingo Molnar <mingo@elte.hu> wrote:
<snip>
> > >
> > > curious: what scheduler/kernel version have you used before?
> >
> > I was using 2.6.23.1 with ck patches.
>
> are you sure? The last -ck patch i can find is for .22:
>
>   http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/
>
> or have they been forward ported? (if yes, do you have an URL for that)
>
> (my guess is you used the 2.6.23.1 scheduler (CFS), so the improvement
> you felt on the laptop is relative to 2.6.23-vanilla in essence - which
> is good news.)

Well, it seems that Matthew has been faster than me :-) Yes, I got -ck
patches from kamikaze sources.

>
> > > > Just a question: does the patch include the fix (divide by
> > > > zero....) you just posted in the stable review for 2.6.23.9?
> > >
> > > yeah.
> >
> > OK, thanks. Have you already tried to apply the patch to 2.6.23.9?
> > Shall we expect some other rejects?
>
> hm:
>
> The latest stable version of the Linux kernel is:           2.6.23.8
>
> so there's no 23.9 yet.
>
>         Ingo
>

I meant the 23.9 patches that Greg KH posted some hours ago for
review. I guess I will find myself in a couple of days.

To answer your latest mail, again I don't have numbers but from my
point ov view:

23.1 < 23.1+ck < 23.8+cfs.24

where 23.1+ck is slightly better than vanilla 23.1 and 23.8+cfs.24 is
much better than 23.1+ck.

My workload is pretty standard, F8+kde+firefox+kmail+amsn, some kernel
compile and so on.

Regards,
Fabio
