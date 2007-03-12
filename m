Return-Path: <linux-kernel-owner+w=401wt.eu-S965536AbXCLKxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965536AbXCLKxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 06:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965535AbXCLKxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 06:53:51 -0400
Received: from www.osadl.org ([213.239.205.134]:37377 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965529AbXCLKxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 06:53:50 -0400
Subject: Re: [patch] change futex_wait() to hrtimers
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mm-commits@vger.kernel.org, npiggin@suse.de,
       drepper@redhat.com, oleg@tv-sign.ru, sebastien.dugue@bull.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <p73bqiyaehp.fsf@bingen.suse.de>
References: <200703110814.l2B8EaI1007615@shell0.pdx.osdl.net>
	 <20070312011259.3834A1801C4@magilla.sf.frob.com>
	 <20070312091006.GF21024@elte.hu>  <p73bqiyaehp.fsf@bingen.suse.de>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 12:00:20 +0100
Message-Id: <1173697220.13341.84.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 12:27 +0100, Andi Kleen wrote:
> Ingo Molnar <mingo@elte.hu> writes:
> > 
> > the only correct approach is the use of hrtimers, and a patch exists for 
> > that - see below. This has been included in -rt for quite some time.
> 
> But isn't that bad for power management? You'll likely get more
> idle wakeups, won't you?

Why so ? It comes more precise, but only once.

	tglx


