Return-Path: <linux-kernel-owner+w=401wt.eu-S1761262AbXFWQyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761262AbXFWQyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 12:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760913AbXFWQxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 12:53:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36730 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761259AbXFWQxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 12:53:38 -0400
Date: Sat, 23 Jun 2007 09:52:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 1/7] ICH Force HPET: Make generic time capable of
 switching broadcast timer
Message-Id: <20070623095215.f882f1cb.akpm@linux-foundation.org>
In-Reply-To: <20070622203822.GA22807@linux-os.sc.intel.com>
References: <20070622203822.GA22807@linux-os.sc.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 22 Jun 2007 13:38:22 -0700 Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
> Auto-detect the presence of HPET on ICH5 or newer platforms and enable
> HPET for broadcast timer. This gives a bigger upperlimit for tickless time
> tick and improves the power consumption in comparison to PIT as broadcast timer.
> 
> This patch:
> 
> Change the broadcast timer, if a timer with higher rating becomes available.
> 

so...  is this the mysterious patchset which will get NOHZ working
on my little Vaio?

I _think_ what's going on here is that your code will go and poke the
hardware to enable the hpet even f the BIOS decided to hide its presence. 
Is that correct?  If so, perhaps the changelog should mention this
explicitly.

> Applies over linux-2.6.22-rc4-mm2 +
> tglx's  patch-2.6.22-rc4-mm2-hrt4 patch

Oh.  Well that tears that then.

Thomas, can I assume that you'll send all this stuff back at me?
