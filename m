Return-Path: <linux-kernel-owner+w=401wt.eu-S933922AbXIBPPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933922AbXIBPPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 11:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbXIBPPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 11:15:25 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:39967 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbXIBPPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 11:15:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LzlI956u0jzIh8BI82THwhByEWEMSBtlgvNqpVYKjZUF92Sk7zNpTuieVUm4R8A5hIsJBEhZhjeRXntbKgMqzEG41MG2MQUcqLocZlqGh+9JQJUvsEb/zjNiywf1qiFUIZQaX91uxT5tiQNjnwYwzByRht7fh3DzUTa+TMvKnvM=
Message-ID: <8bd0f97a0709020815r75fcb225lf44bcb57783b436c@mail.gmail.com>
Date: Sun, 2 Sep 2007 11:15:23 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: the Linux kernel, testsuites, and maybe *you*
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070902065926.GA15487@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0708311422u309ff09cs24dfe64ff535a982@mail.gmail.com>
	 <p733axyxcli.fsf@bingen.suse.de>
	 <8bd0f97a0709011550y833fb5ax7d40cae937789fd8@mail.gmail.com>
	 <20070902065926.GA15487@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/2/07, Andi Kleen <andi@firstfloor.org> wrote:
> On Sat, Sep 01, 2007 at 06:50:30PM -0400, Mike Frysinger wrote:
> > On 02 Sep 2007 00:08:57 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> > > BTW string functions are best tested in user space. That's
> > > a relatively bad example.
> >
> > in theory, maybe ... in reality, i really dont think so
> >
> > the string implementations are spread out over the kernel ... there's
> > implementations in lib/, include/asm-*/, and arch/*/lib/ ... so any
> > test code that would use these sources is going to be an ugly hack to
> > make sure it grabs all the right pieces from all the right places.
>
> string functions tend to be self contained.

"tend to be" does not lend itself to being cleanly tested ... and i
imagine i'd get some pretty heavy resistance if i proposed
re-organzing code just so that i could compile it outside of the
kernel

there is still the ABI issue ... code written in kernel space in pure
asm cannot always be compiled in userspace and work properly/the same

> The other issue to test some of them properly you need unmapped pages
> etc. That gets much easier to do in user space. There are some other
> issues.

you mean testing boundary overflows ?  can be handled with canaries
rather than segfaults i imagine ...
-mike
