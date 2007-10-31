Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159AbXJaBa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbXJaBa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 21:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbXJaBaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 21:30:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:51631 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbXJaBaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 21:30:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Nt8N+nB7wPd/cIZtyN3mtj4WbrDaG744O39Nr11GkZZXKMiC3OKe2kZsVF7qsdvieTS+1mpXnv2fXQGXcRZ5eR5TuTnLR4MskaGXlq73HrNw7ONAtZT2lz4p63NK0D+Af20v323QFl8s3jDw/oI5iQs3SxwaM+TVbYTj7ITD6CI=
Message-ID: <5d6222a80710301830u7976d3eemdd1ed622d59c0a48@mail.gmail.com>
Date: Tue, 30 Oct 2007 23:30:18 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] Add asm-compat.h to x86
Cc: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4727DA13.9080904@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071030145523.GA28026@Krystal> <4727DA13.9080904@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Mathieu Desnoyers wrote:
> > Add asm-compat.h to x86
> >
> > In assembly code and in gcc inline assembly, we need .long to express a "c long"
> > type on i386 and a .quad to express the same on x86_64. Use macros similar to
> > powerpc "PPC_LONG" to express those. Name chosen: ASM_LONG. (didn't feel like
> > X86_LONG was required).
> >
> > This is useful in inline assembly within code shared between 32 and 64
> > bits architectures in x86.
> >
> > More compatible assembly macros could be added in this header later when
> > needed.
> >
> > I had to create this to implement a merged optimized immediate values
> > header for x86.
> >
>
> Seems sound to me, and this header might be a useful place to put other
> things, like macros to emit exceptions, etc...
>
I have already done similar things in the unified pvops patch. But it
was just a few locations, and I didn't fell the need for a common
thing. But it is definitely useful.

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
