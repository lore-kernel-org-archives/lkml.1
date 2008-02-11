Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbYBKOkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbYBKOkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 09:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYBKOkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 09:40:46 -0500
Received: from alephnull.demon.nl ([83.160.184.112]:57306 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbYBKOkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 09:40:45 -0500
X-Greylist: delayed 1471 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Feb 2008 09:40:45 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=jLZm6aOVyQTNkMC2ZeoXt6mT/UCQKqfc4YE801k9ktppuPMHxxnHww2sFKHVf
	ACzLbgnUZMTelWGr187paZ8xQ==
Date: Mon, 11 Feb 2008 15:16:12 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Adrian Bunk <adrian.bunk@movial.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Riku Voipio <riku.voipio@movial.fi>,
       Mikael Pettersson <mikpe@it.uu.se>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: futex local DoS on most architectures
Message-ID: <20080211141612.GC20381@xi.wantstofly.org>
References: <20080211130700.GF27537@movial.fi> <alpine.LFD.1.00.0802111442130.12988@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802111442130.12988@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 02:59:34PM +0100, Thomas Gleixner wrote:

> Subject: futex: disable PI/robust on archs w/o valid implementation
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> We have to disable the complete PI/robust functionality for those
> archs, which do not implement futex_atomic_cmpxchg_inatomic(). The
> code in question relies on a valid implementation and does not expect
> -ENOSYS, which is returned by the stub implementation in
> asm-generic/futex.h
> 
> Pointed out by: Mikael Pettersson, Riku Voipio and Adrian Bunk

FWIW, I reported it originally.


> This patch is intended for easy backporting and needs to be cleaned up
> further for current mainline.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Ingo Molnar <mingo@elte.hu>

Looks good to me.  Thanks.
