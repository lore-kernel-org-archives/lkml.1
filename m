Return-Path: <linux-kernel-owner+w=401wt.eu-S1761420AbXLUAVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761420AbXLUAVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbXLUAVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:21:14 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59099 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752906AbXLUAVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:21:13 -0500
Date: Thu, 20 Dec 2007 16:19:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: trond.myklebust@fys.uio.no, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.24-rc5 x86 architecture no longer Oopses...
Message-Id: <20071220161934.0f55029a.akpm@linux-foundation.org>
In-Reply-To: <20071220234759.GA29776@elte.hu>
References: <1198190447.29917.9.camel@heimdal.trondhjem.org>
	<20071220145415.f737e7f3.akpm@linux-foundation.org>
	<20071220234759.GA29776@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 00:47:59 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> >  		__raw_spin_lock(&die.lock);
> >  		raw_local_save_flags(flags);
> > -		die.lock_owner = smp_processor_id();
> > +		die.lock_owner = raw_smp_processor_id();
> 
> we just disabled irqs with raw_local_save_flags().

<chases x86 spaghetti for a while>

raw_local_save_flags() doesn't disable interrupts?
