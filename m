Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbYL1JjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbYL1JjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 04:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYL1JjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 04:39:06 -0500
Received: from ozlabs.org ([203.10.76.45]:47118 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbYL1JjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 04:39:05 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: clean up setup_clear/force_cpu_cap handling
Date: Sun, 28 Dec 2008 20:08:57 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <49509418.6040905@kernel.org> <20081227102234.GD14639@elte.hu>
In-Reply-To: <20081227102234.GD14639@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812282008.58544.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 December 2008 20:52:34 Ingo Molnar wrote:
> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > Impact: fix and cleanup
> > 
> > setup_force_cpu_cap() only have one user xen
> > but it should not reuse cleared_cpu_cpus. it will have problem
> > for smp.
> > 
> > need to have cpu_cpus_set array too.
> > also need to setup handling before all cpus cap AND
> > 
> > Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>
> > 
> > ---
> >  arch/x86/include/asm/cpufeature.h |    4 ++--
> >  arch/x86/include/asm/processor.h  |    3 ++-
> >  arch/x86/kernel/cpu/common.c      |   17 ++++++++++++-----
> >  3 files changed, 16 insertions(+), 8 deletions(-)
> 
> Rusty, you'll carry this patch in your linux-2.6-boot-params.git tree, 
> right? Merging this in the x86 tree would just needlessly complicate your 
> logistics, right?

Yep, if you're happy to ack, I'm happy to carry.

Cheers,
Rusty.
