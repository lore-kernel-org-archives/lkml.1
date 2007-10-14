Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbXJNAwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbXJNAwh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 20:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbXJNAw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 20:52:29 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:11575 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbXJNAw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 20:52:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HUKn2pHfV22uciPIoxQWl4Ecc+W9cRuG2Fgy3K04l/tv1iW4xuz5L4bh1n1gHSkphB+/rYPDrGZYaW58D8W8sPkCDys+jxfdUuHq2nsIlDipNMkaITPCALUURM5YIglnZu31fWRVLbl3n7s2ABYJIOzjMywe0WXJwsTPtTs23pM=
Message-ID: <5a4c581d0710131752t5cfd2d46s22fce917cd0b5716@mail.gmail.com>
Date: Sun, 14 Oct 2007 02:52:26 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: patrizio.bassi@gmail.com
Subject: Re: 2.6.23-git3 compilation broken, asm headers missing?
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Kernel," <linux-kernel@vger.kernel.org>
In-Reply-To: <47115F09.3090504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4710AD07.70000@gmail.com>
	 <alpine.LFD.0.9999.0710131348310.12017@localhost.localdomain>
	 <47115F09.3090504@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/07, Patrizio Bassi <patrizio.bassi@gmail.com> wrote:
> Thomas Gleixner ha scritto:
> > On Sat, 13 Oct 2007, Patrizio Bassi wrote:
> >
> >> include/linux/types.h:15:23: error: asm/types.h: No such file or directory
> >> In file included from include/linux/prefetch.h:13,
> >>                  from include/linux/list.h:8,
> >>                  from include/linux/module.h:9,
> >>                  from include/linux/crypto.h:21,
> >>                  from arch/x86/kernel/asm-offsets_32.c:7,
> >>                  from arch/x86/kernel/asm-offsets.c:2:
> >>
> >> full log attached.
> >>
> >
> > That's a stale include/asm symlink. Can you save your .config file and do
> >
> > make mrproper
> >
> > please and check if it's solved.
> >
> > Thanks,
> >
> >       tglx
> >
> >
> >
> seems ok now
>
> Thanks!

Same issue here, and as well making mrproper fixes it.

Thanks, ciao,

--alessandro

 "you feel the sweet breath of time
  it's whispering, its truth not mine"

   (Interpol, 'No I In Threesome')
