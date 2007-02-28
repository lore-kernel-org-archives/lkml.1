Return-Path: <linux-kernel-owner+w=401wt.eu-S1750951AbXB1HYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750951AbXB1HYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 02:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbXB1HYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 02:24:21 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:31270 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbXB1HYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 02:24:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z29XB02zywAHA8bwZSoewakCFQ+P97YE20KMgr/y941WD7wR7+4QxLpVS+YSkRAws5TL5Zd2uoEIpSwYsyElTSNtVHa35QiZ55BmY9/M7OgM0WSLGw+oPFjtktXUWPwWkhKfQeTN5cw0dOIa0D4qYEVhd1E5/HZZ53l4ZbKmBfI=
Message-ID: <9c21eeae0702272323x73ad593lf6b99ea7dd23056@mail.gmail.com>
Date: Tue, 27 Feb 2007 23:23:57 -0800
From: "David Brown" <dmlb2000@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc2
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/27/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> Oh well.. I'm not very proud of this, because quite frankly, -rc2 has way
> more changes than I really like.
>
> And yeah, it's largely my fault, because I simply missed a V4L/DVB merge
> that came in before the merge window closed, but since I didn't notice it
> didn't make -rc1, and as such it got merged late and is in -rc2 instead.
>
> But because I'll flail around wildly and rather blame anything else than
> my own incompetence, I'll just claim that all the other kernel developers
> have been irresponsible, and caused -rc2 to be bigger than needed. In some
> areas (you know who you are) it may even be true..
>
> Apart from the V4L/DVB merge, we've got a late PARISC update, and a number
> of driver updates (ata, networking, usb) changes. Along with the normal
> smattering of random stuff (core networking, selinux, infiniband, agp,
> mips, arm).
>
> Anyway, I really hope the thing starts calming down now, and everybody
> should take a hard look at the regressions lists that Adrian has started
> sending out. We already fixed some of them, but there is more to go..
>
> Thanks,
>
>                 Linus

I got this compile error:

  CC      arch/i386/kernel/io_apic.o
arch/i386/kernel/io_apic.c: In function 'setup_IO_APIC_irqs':
arch/i386/kernel/io_apic.c:1357: error: 'struct irq_desc' has no
member named 'affinity'
arch/i386/kernel/io_apic.c: In function 'io_apic_set_pci_routing':
arch/i386/kernel/io_apic.c:2878: error: 'struct irq_desc' has no
member named 'affinity'
make[1]: *** [arch/i386/kernel/io_apic.o] Error 1
make: *** [arch/i386/kernel] Error 2

didn't happen with rc1

- David Brown
