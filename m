Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbZIVPty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbZIVPty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbZIVPtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:49:53 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:52299 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbZIVPtw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:49:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=sioVDcRsgJj4SLJwrTt2D052ge++tRcVZT7vqd0xyycMw6owAGWOKOv2ziI+bW/er5
         PsNO8Oy0fiPqaBJZsSWEnIXTC6FKY3KxLtqEb7YpxyVPQgujm9cSABa5gxgKJSIBjhXn
         VsuJ/VC+k2DEOW4W9r8SNW9X/0yK44OY9kRcs=
MIME-Version: 1.0
In-Reply-To: <20090921214046.GA17243@redhat.com>
References: <817ecb6f0909101950v2fc6dc6u5cbc40cd9a9dde77@mail.gmail.com>
	 <20090921214046.GA17243@redhat.com>
Date: Tue, 22 Sep 2009 11:49:55 -0400
Message-ID: <817ecb6f0909220849t2142f6bdhdeb0180dedc646d2@mail.gmail.com>
Subject: Re: [PATCH v6] RO/NX protection for loadable kernel modules
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: Dave Jones <davej@redhat.com>, Siarhei Liakh <sliakh.lkml@gmail.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Siarhei,
>  I tried out this patch on 2.6.31, and got the following trace during bootup..
>
> ------------[ cut here ]------------
> WARNING: at kernel/trace/ftrace.c:1003 ftrace_bug+0x198/0x27e() (Not tainted)
> Hardware name: VGN-Z540N
...
> ---[ end trace 95b33ebf87286ae6 ]---
> ftrace faulted on writing [<ffffffffa0000193>] video_output_register+0x11/0x10a [output]
>
>
> I guess ftrace is trying to NOP out something in the modules which
> are marked read-only ?

Entirely possible. I will review ftrace and make sure the patch
accounts for this.

Thank you.
