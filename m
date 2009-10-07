Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbZJGKmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbZJGKmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 06:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758862AbZJGKme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 06:42:34 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:57518 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758847AbZJGKmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 06:42:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YeKnFlFSiEKgQu3NAOqVPfw3Q6ExGpH7+YZZhXoLSqQ2IRYORMp6NHY3RaKvp+EURo
         RuMR6gNKoSGSAJ0KFQn4VXYcI2Ugvwbm37Zafg+/5GZHpkdvBy8t4VmkdF1iuEGv104q
         wE4Icq7xwV5ZWxvmpHn35GiNZ0yD4QsxDMOgk=
Message-ID: <4ACC706E.5000002@gmail.com>
Date: Wed, 07 Oct 2009 19:41:50 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: Russell King <rmk+kernel@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] arm: use unified discard definition in linker script
References: <4ACC6D74.7010001@tuffmail.co.uk>
In-Reply-To: <4ACC6D74.7010001@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> I selfishly request an Acked-by for the following. My aim is to submit it as
> part of a larger series ("module: Speed up symbol resolution during module
> loading") which would not go through the ARM tree.
> 
> ------------------------------------------------------------------->
> From 52c4a00b22fecf3ecb352618356bb61f7f4b261b Mon Sep 17 00:00:00 2001
> From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Date: Wed, 7 Oct 2009 11:08:34 +0100
> Subject: [PATCH] arm: use unified discard definition in linker script
> 
> Commit 023bf6f "linker script: unify usage of discard definition"
> changed the linker scripts for all architectures except for ARM.
> I can find no discussion about this exception, so here are the changes
> for ARM.
> 
> These changes are exactly parallel to the ia64 case.
> 
> "ia64 is notable because it first throws away some ia64 specific
>  subsections and then include the rest of the sections into the final
>  image, so those sections must be discarded before the inclusion."
> 
> Not boot-tested.  In build testing, the modified linker script generated
> an identical vmlinux file.
> 
> 
> [I would like to be able to rely on this unified discard definition.
>  I want to sort the kernel symbol tables to allow faster symbol
>  resolution during module loading. The simplest way appears to be
>  to generate sorted versions from vmlinux.o, link them in to vmlinux,
>  _and discard the original unsorted tables_.
> 
>  This work is driven by my x86 netbook, but it is implemented at a
>  generic level. It is possible it will benefit some ARM systems also.]
> 
> 
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> CC: Tejun Heo <tj@kernel.org>

Most likely omission by simple mistake.  The change looks fine to me
but I don't have any arm machine to test it.

Acked-by-without-testing: Tejun Heo <tj@kernel.org>

-- 
tejun
