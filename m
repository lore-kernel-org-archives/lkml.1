Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbYHOPcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbYHOPcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbYHOPc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:32:29 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64095 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751680AbYHOPc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:32:28 -0400
Date: Fri, 15 Aug 2008 16:31:57 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, hpa@zytor.com,
       yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 8/8] x86: apic - unify init_bsp_APIC
In-Reply-To: <20080815144509.GA7178@lenovo>
Message-ID: <Pine.LNX.4.55.0808151614460.11843@cliff.in.clinika.pl>
References: <20080814183428.550709025@gmail.com> <20080814184652.475361864@gmail.com>
 <Pine.LNX.4.55.0808142043150.7213@cliff.in.clinika.pl>
 <aa79d98a0808142341k6a074c8fh41e44a9f23c14f0a@mail.gmail.com>
 <20080815115147.GA32726@elte.hu> <Pine.LNX.4.55.0808151303410.11843@cliff.in.clinika.pl>
 <20080815134801.GA14103@elte.hu> <20080815144509.GA7178@lenovo>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008, Cyrill Gorcunov wrote:

> Since lapic_is_integrated is just eliminated on 64bit I thought
> it's better to have smooth code flow as much as possible. By 'smooth'
> I mean to not use #ifdef until there is no chance to escape from.

 Of course!

> And Maciej - you're so right - if someone will take a look on the
> apic_64.c code now he will be quite wondered what lapic_is_integrated
> is doing in 64bit code.

 I just questioned the purpose of reformatting the comment.  I see no
problem with lapic_is_integrated() appearing in 64-bit code -- if someone
cannot figure out why it would appear there, they better practised some
thinking at home before coming back.  We have plenty of places with such
constructs that expand to literals for some configurations all over our
tree anyway.

  Maciej
