Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbZGGByY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbZGGByY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 21:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbZGGByR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 21:54:17 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:36910 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbZGGByQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 21:54:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f58bdGr7PRXvfRTuGx4dpPts93NLfemSaxFQi3bgAA1nsM6nOypmlxq6D6ko4ffdQe
         cLmUhBWnkh2ZUgqP/d7dVFgugEOGHAnmoIl8hmqD+Kd9yo4sPicgOB3GwTYQCt1rpUa0
         ObsMYmClErG6oBpg2wO5oQ4zcfg49Phx7fzEY=
MIME-Version: 1.0
In-Reply-To: <200906301538.44684.arnd@arndb.de>
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com>
	 <200906301448.55064.arnd@arndb.de>
	 <20090630140945.0784e174@lxorguk.ukuu.org.uk>
	 <200906301538.44684.arnd@arndb.de>
Date: Tue, 7 Jul 2009 09:54:20 +0800
Message-ID: <d82e647a0907061854l7d862191w1a9aa667eca7abb5@mail.gmail.com>
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers() in 
	dma_sync_*_for_cpu
From: Ming Lei <tom.leiming@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Joerg Roedel <joerg.roedel@amd.com>,
       fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Russell King <rmk@arm.linux.org.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/30 Arnd Bergmann <arnd@arndb.de>:
> On Tuesday 30 June 2009, Alan Cox wrote:
> Well, not even that. dma-mapping-common.h only makes sense on architectures
> that have multiple dma-mapping implementations (parisc, mips, arm, powerpc,

It seems that there is only one dma-mmaping implementation on ARM, doesn't it?
Is it necessary that using dma-mapping-common.h on ARM?

> sparc, ia64 and x86, possibly alpha). All others including frv only need a
> nommu case anyway and would not use dma-mapping-common.h but could be
> changed to use something like the dma-mapping-linear.h I worked on recently.




-- 
Lei Ming
