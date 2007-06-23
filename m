Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbXFWXRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbXFWXRv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 19:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbXFWXRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 19:17:44 -0400
Received: from www.osadl.org ([213.239.205.134]:58688 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752110AbXFWXRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 19:17:44 -0400
Subject: Re: [PATCH 1/7] ICH Force HPET: Make generic time capable of
	switching broadcast timer
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070623095215.f882f1cb.akpm@linux-foundation.org>
References: <20070622203822.GA22807@linux-os.sc.intel.com>
	 <20070623095215.f882f1cb.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 24 Jun 2007 01:17:40 +0200
Message-Id: <1182640660.20203.213.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-23 at 09:52 -0700, Andrew Morton wrote:
> I _think_ what's going on here is that your code will go and poke the
> hardware to enable the hpet even f the BIOS decided to hide its presence. 
> Is that correct?  If so, perhaps the changelog should mention this
> explicitly.
> 
> > Applies over linux-2.6.22-rc4-mm2 +
> > tglx's  patch-2.6.22-rc4-mm2-hrt4 patch
> 
> Oh.  Well that tears that then.
> 
> Thomas, can I assume that you'll send all this stuff back at me?

I sent out a V3 queue today, but the aggregate of my queue and Venki's
HPET stuff + HPET force enable for non Intel chip sets is available as a
full queue here:

http://www.tglx.de/projects/hrtimers/2.6.22-rc4-mm2/patch-2.6.22-rc4-mm2-hrt6.patches.tar.bz2

I can resend the 40 patches if you want, but they are out on LKML
already (-hrt and the hpet ones), so there is little value to spam
everyones inbox with the same stuff again.

	tglx


