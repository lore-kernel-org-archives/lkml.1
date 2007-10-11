Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbXJKBuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbXJKBuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 21:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbXJKBum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 21:50:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:55837 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbXJKBul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 21:50:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jk60M1VyaNsN6kBRKq4dnNYfqafD3x/qrEY5EMZ+FMOrEevL5sJfBmkCff6293NReSngee1D5i1YVI3hPKlm7rcKUlRFbwv1mwmqRqya7OtoG2nSyRJICQnSELuIWrIBlKp+WbGqsdqx5gogCaPCyqr+W7QQOm8wGZJL5YOuouI=
Message-ID: <f9d2a5e10710101850u26144173s2473f8c2dad62c3b@mail.gmail.com>
Date: Wed, 10 Oct 2007 18:50:39 -0700
From: "Russ Dill" <russ.dill@gmail.com>
To: "David Newall" <david@davidnewall.com>
Subject: Re: [OT] Argument with an OS professor over profile=3
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <470D7E08.10209@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f9d2a5e10710101708l707eb619l6446f2e648ee016e@mail.gmail.com>
	 <470D7E08.10209@davidnewall.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/07, David Newall <david@davidnewall.com> wrote:
> Russ Dill wrote:
> > I've been having a back and forth going for a while with my TA and OS
> > professor on the meaning of profile=3 and have been unable to convince
> > either of them. The basic question is if profile=3 is passed to kernel
> > with an 8MB text section, how big is the allocated profile buffer. His
> > answer is 1MB....
> >
> >         if (prof_shift) {
> >                 unsigned int size;
> >                 /* only text is profiled */
> >                 prof_len = (unsigned *) &_etext - (unsigned *) &_stext;
> >
> You stipulated 8MB text, but this calculates in unsigned ints, so
> prof_len = 2M.

Please have a look at my followup, I accidentally sent out code that I
had used to produce an answer as my prof thought it works. The actual
code casts to (unsigned long). Sigh, I've shot myself in the foot...

Anyway, the book (and the class covers 2.4.1) and the associated code
has since moved from init/main.c. Here's how the 2.4.1ish code looks:

http://tldp.org/HOWTO/Linux-i386-Boot-Code-HOWTO/init_main.html
