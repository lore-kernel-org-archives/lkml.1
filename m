Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbXJAOdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbXJAOdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 10:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbXJAOdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 10:33:43 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:23281 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbXJAOdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 10:33:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R8LXWmi9abTJLnIn3+wAL+6rNYHFNL5rLGEctfT55zaD+Qppcfy3JTQXpQ2crWjckmwaKOhjZZ2dFxFqgE/GSKoKArBCnGoJDOCk4ytKV0NBR6ozlsIzUCGkt0QqEkzwjLC9vVwuzYn3pp+SUxocQQJXGdBvXLynqgCbmOcZ45I=
Message-ID: <b70f2f960710010733m6932c0b3raa35d59b393538fd@mail.gmail.com>
Date: Mon, 1 Oct 2007 18:33:40 +0400
From: "Mikhail Kshevetskiy" <mikhail.kshevetskiy@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: Fwd: x86_64 and AMD with C1E
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LRH.0.999.0710011612001.7353@www.tglx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071001101532.025d652f@localhost>
	 <p73r6kf6uwz.fsf@bingen.suse.de>
	 <b70f2f960710010546k4658aa1ay466f243ac707c989@mail.gmail.com>
	 <b70f2f960710010550i30ae48bu31f137fe46d70611@mail.gmail.com>
	 <alpine.LRH.0.999.0710011612001.7353@www.tglx.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/10/1, Thomas Gleixner <tglx@linutronix.de>:
> On Mon, 1 Oct 2007, Mikhail Kshevetskiy wrote:
> > No, it boot and work normally. The only thing i bother, is the
> > additional 260 timer interrupts per seconds.
> > Here is short result:
> >
> > c1e enabled:
> >   -- power consumption about 23 watts
> >   -- there is only C1 power state enabled
> >   -- there are about 260 timer interrupts per seconds
> > tested with  x86_64(2.6.22, 2.6.23-rc8, 2.6.23-rc8-hrt1 ),
> > i386(2.6.21, 2.6.22, 2.6.23-rc5-hrt1)
> >
> > c1e disabled:
> >   -- power consumption about 27 watts
> >   -- there are no any power state enabled (including C1)
> >   -- there are no additional 260 timer interrupts per seconds
> > tested with 2.6.23-rc6-hrt1/x86_64.
> >
> > I want to reduce the power consumption of my notebook. I see the 2 possibility:
> >   -- remove 260 additional timer interrupts (c1e enabled case )
>
> There is work in progress on a patch, which allows to utilize the hpet
> timers as per cpu timers. This should solve the problem. Be patient.

I can test it on i386/x86_64 architectures.

Mikhail Kshevetskiy
