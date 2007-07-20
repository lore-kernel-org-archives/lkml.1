Return-Path: <linux-kernel-owner+w=401wt.eu-S932461AbXGTU7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbXGTU7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 16:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755623AbXGTU7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 16:59:37 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:29623 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbXGTU7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 16:59:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aM4FQ+Ny65KyjgJCzReDqE76R+LkFetDQKXiXV/8uAKnHqnObuYMX0bOSbU+0i0TDG1sy6AifEl+AlUxAnZUQ0exvwDsJkFdYDEb1s8qg3xajsosd6dGwOn2v0Euyxv3wxKGWy3s+jJAU00fUnRXjz24nxtb7r/SISliTuWByKA=
Message-ID: <8bd0f97a0707201359m41d91098qf35d462d4a9c9071@mail.gmail.com>
Date: Fri, 20 Jul 2007 16:59:35 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Bernd Schmidt" <bernds_cb1@t-online.de>
Subject: Re: blackfin - cmpxchg not atomic ?
Cc: robin.getz@analog.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070720204507.GA15760@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070720202807.GA15009@Krystal>
	 <8bd0f97a0707201336l6bed7c24i7014333ce356417f@mail.gmail.com>
	 <20070720204507.GA15760@Krystal>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> * Mike Frysinger (vapier.adi@gmail.com) wrote:
> > On 7/20/07, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > >I am currently passing through each architectures adding a
> > >cmpxchg_local() to each system.h, and I notice that you disable
> > >interrupts in your cmpxchg() implementation, why are you doing so ?
> >
> > because Blackfin lacks any atomic instructions
> >
> > >Also, does you assembly stub _really_ modify memory atomically ? If yes,
> > >then there should be no need for disabling interrupts. Else, I see a
> > >major problem with SMP.
> >
> > that isnt the only problem with SMP on Blackfin
> >
> > >I also don't like the comment in asm-blackfin/atomic.h :
> > >
> > > * Generally we do not concern about SMP BFIN systems, so we don't have
> > > * to deal with that.
> > >
> > >I have seen on the blackfin website that you actually sell a board with
> > >SMP. Why aren't you caring about it ?
> >
> > just because a processor has more than one core does not make it SMP
>
> I see, thanks for the reply. Is there a particular reason for
> implementing system.h/cmpxchg() in assembly rather that in plain C then?

honestly ?  probably not :)

Bernd would probably know best (he's good like that)
-mike
