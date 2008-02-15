Return-Path: <linux-kernel-owner+w=401wt.eu-S1762664AbYBOBUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762664AbYBOBUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 20:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbYBOBUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 20:20:10 -0500
Received: from www.tglx.de ([62.245.132.106]:46723 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301AbYBOBUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 20:20:09 -0500
Date: Fri, 15 Feb 2008 02:19:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: adrian.bunk@movial.fi, mingo@elte.hu, linux-kernel@vger.kernel.org,
       riku.voipio@movial.fi, mikpe@it.uu.se, buytenh@wantstofly.org,
       rusty@rustcorp.com.au, stable@kernel.org
Subject: Re: futex local DoS on most architectures
In-Reply-To: <20080214134642.600282f1.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0802150216350.12988@apollo.tec.linutronix.de>
References: <20080211130700.GF27537@movial.fi> <alpine.LFD.1.00.0802111442130.12988@apollo.tec.linutronix.de> <20080214134642.600282f1.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008, Andrew Morton wrote:
> > This patch is intended for easy backporting and needs to be cleaned up
> > further for current mainline.
> 
> So...
> 
> I queued up this version with a cc to stable under the assumption that this
> is the patch which should be applied to 2.6.x.y, but this version is not
> the one which will go into 2.6.25.
> 
> Correct?
> 
> If so: messy.  The stable guys might want to wait until they see the real
> 2.6.25 patch and perhaps prefer to backport that version.

Yup. I worked out a sane solution, which allows runtime detection. The
compile time solution is not perfect, as there is already arch code
which checks cpu features on runtime.

Patches follow in separate mail.

Thanks,
	tglx

