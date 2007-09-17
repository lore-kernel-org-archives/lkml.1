Return-Path: <linux-kernel-owner+w=401wt.eu-S1757818AbXIQUcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbXIQUcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbXIQUbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:31:55 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:33111 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758256AbXIQUbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:31:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HIx3OIPvKqLt4MWLLbJvTh0t18C8Ydv+k5vk5Rj1KzbYmXMcf3iE6e7u8t0NggL3f3wVjmCMaxNe3lWmSvQu81CUShzqCW4JWTT3Tqa/4LWaIxdrhkc28IhMZJqS3bXBRrYE28cNOXUnPdoBSGUDhIrPoJysSE2ln9p/nfkzjIc=
Message-ID: <38b2ab8a0709171331s4cb302c3g5d0a4214981a2980@mail.gmail.com>
Date: Mon, 17 Sep 2007 22:31:50 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Ulrich Drepper" <drepper@gmail.com>
Subject: Re: x86_64: vsyscall vs vdso
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <a36005b50709161346t544d3927mfbca537c869c3c58@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0709161324p6841c1f9h6f9422b0e6c4b5cd@mail.gmail.com>
	 <a36005b50709161346t544d3927mfbca537c869c3c58@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/16/07, Ulrich Drepper <drepper@gmail.com> wrote:
> On 9/16/07, Francis Moreau <francis.moro@gmail.com> wrote:
> > Another question: is vdso going to replace vsyscall at all ? If so how

It's weird,  because it seems that vsyscalls are only done by x86_64,
all others archs have only vdso... so they seem to forget about
statically linked apps...

> > are statically programs going to be handled ?
>
> Unfortunately the vsyscalls cannot ever go completely away.
> Statically linked apps, the bane of progress, will need them.

Actually if we could easily retrieve the vdso in a process memory
mapping (through a new syscall or /proc/self/maps), it should be easy
for gcc/ld to statically links vdso functions into a statically linked
app, shouldn't it ?

-- 
Francis
