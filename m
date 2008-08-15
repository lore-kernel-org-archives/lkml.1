Return-Path: <linux-kernel-owner+w=401wt.eu-S1760359AbYHOQfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760359AbYHOQfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 12:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756095AbYHOQfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 12:35:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:22744 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbYHOQff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 12:35:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kw/IW0ToQHfSO59rzhb4pmLZH/97OPN//SX4wUx5PjU63OymhkMbNvA1B4fCXMVzgv
         ZXJArtu7eQfJrvT5nxM3MhfosITtwwRBkFzyvvCvzpazlGk8PCEIM0kxiA8eaGh99Ny8
         Qnlt3Gsg5+E8fSqYnlmhExnCF4/AgS34Qoh+o=
Date: Fri, 15 Aug 2008 20:35:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, hpa@zytor.com,
       yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 8/8] x86: apic - unify init_bsp_APIC
Message-ID: <20080815163537.GB7178@lenovo>
References: <20080814183428.550709025@gmail.com> <20080814184652.475361864@gmail.com> <Pine.LNX.4.55.0808142043150.7213@cliff.in.clinika.pl> <aa79d98a0808142341k6a074c8fh41e44a9f23c14f0a@mail.gmail.com> <20080815115147.GA32726@elte.hu> <Pine.LNX.4.55.0808151303410.11843@cliff.in.clinika.pl> <20080815134801.GA14103@elte.hu> <20080815144509.GA7178@lenovo> <Pine.LNX.4.55.0808151614460.11843@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0808151614460.11843@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Fri, Aug 15, 2008 at 04:31:57PM +0100]
| On Fri, 15 Aug 2008, Cyrill Gorcunov wrote:
| 
| > Since lapic_is_integrated is just eliminated on 64bit I thought
| > it's better to have smooth code flow as much as possible. By 'smooth'
| > I mean to not use #ifdef until there is no chance to escape from.
| 
|  Of course!
| 
| > And Maciej - you're so right - if someone will take a look on the
| > apic_64.c code now he will be quite wondered what lapic_is_integrated
| > is doing in 64bit code.
| 
|  I just questioned the purpose of reformatting the comment.  I see no
| problem with lapic_is_integrated() appearing in 64-bit code -- if someone
| cannot figure out why it would appear there, they better practised some
| thinking at home before coming back.  We have plenty of places with such
| constructs that expand to literals for some configurations all over our
| tree anyway.
| 
|   Maciej
| 

Ah... it was about comment,  now it's clear what you meant (for me).

		- Cyrill -
