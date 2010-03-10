Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab0CJPHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:07:07 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55902 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab0CJPHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:07:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=v3mNjFZi7rYohEQUKpDHk5Q7JxeJDorL2xmZaLipGl2zbuEXx1+Bykhnw8cI35xgSZ
         +wOkGppT2t9QDNKswPsDD7kjDCwzP8eSUKmcrIZcLdWEnsj5AIQ4rVhvVPiIpQ6wGiyw
         xphFejC0b06sXD+vVcf/bFJR4/7vfvfp9uBcY=
MIME-Version: 1.0
In-Reply-To: <20100310133240.GA9606@elte.hu>
References: <817ecb6f1001311527w7914ab20sf15b800dcaa37df7@mail.gmail.com>
	 <tip-01ab31371da90a795b774d87edf2c21bb3a64dda@git.kernel.org>
	 <20100222105457.GA31148@elte.hu> <20100222110106.GA7206@elte.hu>
	 <4B82BCB0.9060903@zytor.com> <20100222172153.GA28638@elte.hu>
	 <817ecb6f1003061144r3defbe0eg74e23e0986f8e42d@mail.gmail.com>
	 <20100310133240.GA9606@elte.hu>
Date: Wed, 10 Mar 2010 10:06:58 -0500
Message-ID: <817ecb6f1003100706l88ceffp72fd8c72d34a9fd8@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86, mm: NX protection for kernel data
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, jmorris@namei.org,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, tglx@linutronix.de,
       jiang@cs.ncsu.edu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Any suggestions on how should I proceed forward in troubleshooting this issue?
>
> Can you reproduce it in KVM?

Yes, it crashes in KVM.

> If yes then that might give you a more debuggable state than a crashed native
> system.

Running kernel in KVM under kgdb with a watchpoint set for
($eip>=_etext)&&($eip<=_edata) still produces a dump but without ever
triggering the watchpoint.
I was hoping that some Kernel Locking Guru would say "take a look at
__xxx_yyy_zzz(), the things it does always looked suspicious to me."
:)

But joking aside, I would really appreciate ANY advice on debugging
this problem, as my best idea at this point is to pretty much
single-step through the whole thing... And since I am not familiar
with lock debugging at all, this will take a long time to figure out
on my own.

Thank you, guys.
