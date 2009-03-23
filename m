Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbZCWLRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbZCWLRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 07:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbZCWLRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 07:17:10 -0400
Received: from www.tglx.de ([62.245.132.106]:40260 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbZCWLRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 07:17:08 -0400
Date: Mon, 23 Mar 2009 12:14:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Roland McGrath <roland@redhat.com>
cc: mtk.manpages@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Linux API <linux-api@vger.kernel.org>
Subject: Re: [patch 0/3] add rt_tgsigqueueinfo syscall [RESEND]
In-Reply-To: <20090227000352.7D32BFC339@magilla.sf.frob.com>
Message-ID: <alpine.LFD.2.00.0903231213180.29264@localhost.localdomain>
References: <20090226133339.875832967@linutronix.de> <cfd18e0f0902261319v20ba7bd1pcc91ccc4b2c7d577@mail.gmail.com> <20090227000352.7D32BFC339@magilla.sf.frob.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland,

On Thu, 26 Feb 2009, Roland McGrath wrote:

> I don't see any rationale for rt_tgsigqueueinfo and rt_sigqueueinfo to
> differ in their treatment of si_pid/si_uid (whatever that is).  It just
> seems like common sense that they would match.
> 
> Oleg and/or Sukadev have some patches floating around (maybe all in -mm?)
> that relate to setting those.

You mean having the same logic as we have in {t,tg,}kill syscalls for
rt_sigqueueinfo as well ?

Is there anything else which stands in the way of getting the
rt_tgsigqueueinfo interface merged ?

Thanks,

	tglx
