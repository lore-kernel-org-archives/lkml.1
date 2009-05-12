Return-Path: <linux-kernel-owner+w=401wt.eu-S1759051AbZELP53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbZELP53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbZELP4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:56:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52140 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753102AbZELP4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:56:48 -0400
Date: Tue, 12 May 2009 16:57:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nick Piggin <npiggin@suse.de>
Cc: Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: uses of cmpxchg/xadd in spinlock.h and rwsem.h vs. CONFIG_M386
Message-ID: <20090512165727.363bf109@lxorguk.ukuu.org.uk>
In-Reply-To: <20090512153732.GA31131@wotan.suse.de>
References: <4A09AF8402000078000007DC@vpn.id2.novell.com>
	<20090512153732.GA31131@wotan.suse.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh, hmm, we do actually attempt to support 386 SMP kernels... I thought
> that config wasn't allowed, but looking at the atomic.h code, it has
> ifdef fallbacks.

We don't support running on SMP 386 hardware but we do in theory support
running uniproc on it.

