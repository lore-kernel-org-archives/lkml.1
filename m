Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbXFLA3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbXFLA3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 20:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbXFLA3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 20:29:10 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:54682 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbXFLA3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 20:29:08 -0400
Date: Mon, 11 Jun 2007 17:27:47 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Greg KH <greg@kroah.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andi Kleen <ak@suse.de>, Ralf Baechle <ralf@linux-mips.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Stable Team <stable@kernel.org>,
       Richard Henderson <rth@twiddle.net>
Subject: Re: [stable] [PATCH] INPUT: Sanitize PIT locking in pcspkr
Message-ID: <20070612002747.GJ3723@sequoia.sous-sol.org>
References: <1179408962.3764.72.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179408962.3764.72.camel@chaos>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> The PC-speaker code has a quite creative method to serialize access to
> the PIT: It uses a local lock.
> 
> On i386 and x86_64 the access to the PIT is serialized by a lock in the
> architecture code. The separate locking in the PC-speaker code ignores
> the global lock and creates a nasty race between the PC-speaker and the
> PIT clock source / events code on SMP machines.
> 
> Use the global i8253_lock instead of the local i8253_beep_lock, when
> compiled for i386/x86_64.

Seems this one got lost?

thanks,
-chris
