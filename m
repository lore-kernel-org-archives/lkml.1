Return-Path: <linux-kernel-owner+w=401wt.eu-S1751755AbZHSJ5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbZHSJ5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbZHSJ5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:57:09 -0400
Received: from www.tglx.de ([62.245.132.106]:46510 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbZHSJ5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:57:09 -0400
Date: Wed, 19 Aug 2009 11:56:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Beulich <JBeulich@novell.com>
cc: mingo@elte.hu, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: make use of inc/dec conditional
In-Reply-To: <4A8BE0BE0200007800010890@vpn.id2.novell.com>
Message-ID: <alpine.LFD.2.00.0908191150340.3361@localhost.localdomain>
References: <4A8BCA850200007800010836@vpn.id2.novell.com> <1250668860.7583.327.camel@twins> <4A8BDB51020000780001086E@vpn.id2.novell.com> <alpine.LFD.2.00.0908191105260.3361@localhost.localdomain> <4A8BE0BE0200007800010890@vpn.id2.novell.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009, Jan Beulich wrote:

> >>> Thomas Gleixner <tglx@linutronix.de> 19.08.09 11:06 >>>
> >You still do not tell on which machines the INC/DEC instructions
> >should be avoided and why. GCC avoiding it is not a convincing
> >argument.
> 
> On Pentium4 (Prescott/Nocona) inc/dec not modifying the carry flag cause
> an extra instruction dependency on EFLAGS, and hence extra latency in
> when the instruction can be scheduled for execution.

Do we really care that much about those electronic heaters which are
scheduled for darwinistic extinction since their introduction ?

Thanks,

	tglx
