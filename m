Return-Path: <linux-kernel-owner+w=401wt.eu-S1759843AbXJXV04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759843AbXJXV04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759573AbXJXV0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:26:43 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:39028 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759560AbXJXV0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:26:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a02kfNF4oKE1Nq+rB1FIid80o85UwZJNTHjMuZ0irroPND4KHZCejhvSNt+mVwo3FdX6OoSw6sWO35MgFIVeu4bz+KZEQxxSBy54Ub58C3uafdwZmWQdiIw0PJKRbFtTfbFPHP88FGjhFvE1cEaZ71V+fliSRwwEAY6RJh8c/DE=
Message-ID: <b70f2f960710241426y40d25647v3f25b275fad5ce76@mail.gmail.com>
Date: Thu, 25 Oct 2007 01:26:38 +0400
From: "Mikhail Kshevetskiy" <mikhail.kshevetskiy@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: x86_64 and AMD with C1E
Cc: linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <4718DDB7.7070707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071001101532.025d652f@localhost> <4718DDB7.7070707@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/10/19, Chuck Ebbert <cebbert@redhat.com>:
> On 10/01/2007 02:15 AM, Mikhail Kshevetskiy wrote:
> > Hello,
> >
> > I have ASUS F3T notebook with dualcore AMD processor. It has c1e feature
> > enabled. I test linux-2.6.23-rc8-hrt1 kernel. Everything is work (thanks
> > to lapic disable patch), but i have to many processor interrupts per
> > seconds (about 260 additional timer interrupts).
> >
> > The same situation can be observed for linux-2.6.22. Moreover the same
> > problem exist with i386 kernel (test with 2.6.21, 2.6.22, 2.6.22-hrt6,
> > 2.6.23-rc5-hrt1).
> >
> > The problem disappear when I disable c1e on both cores. In this case
> > lapic is not disabled. The back side of this patch is the disabling of
> > all C-state including C1. As result the power consumption increase from
> > 23 (c1e enabled) to 27 (c1e disabled) watts.
> >
> > I fill something wrong here.
> > Is it possible to reduce the amount of timer interrupts?
> > Is it possible to force enable C1,C2 and C3 states when c1e disabled?
> >
>
> How are you disabling C1E?
>
>
dirty hack, i just follow the FreeBSD way and clear C1e bit in lapic
initialization code. I make it for test purpose only, so i do not produce a
patch.

Mikhail
