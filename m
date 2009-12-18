Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbZLRRBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbZLRRBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbZLRRBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:01:32 -0500
Received: from www.sr71.net ([198.145.64.142]:54438 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671AbZLRRBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:01:31 -0500
Subject: Re: -tip: origin tree boot crash
From: Dave Hansen <dave@sr71.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20091218164509.GA14574@elte.hu>
References: <20091218164509.GA14574@elte.hu>
Content-Type: text/plain
Date: Fri, 18 Dec 2009 09:01:29 -0800
Message-Id: <1261155689.27372.1444.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 17:45 +0100, Ingo Molnar wrote:
> Today's -tip crashes during bootup (x86 allyesconfig, 64-bit), due to this 
> commit from yesterday's upstream -git tree:
> 
>  commit a328e95b82c1b8483ae5ab2f809140664d7f6c92
>  Author: Dave Hansen <dave@sr71.net>
>  Date:   Thu Oct 1 15:43:32 2009 -0700
> 
>     leds: LED driver for Intel NAS SS4200 series (v5)
> 
> The crash serial log is attached below. I suspect this driver was not booted 
> on hardware that does not have that LED interface?

I just double-checked it again on a couple of my systems and it seems to
deny loading the module correctly.

What kind of hardware is this?  Could you send me 'dmidecode' output?

I'm wondering if your hardware matched the "Intel" string somehow and
the dmi code didn't bother to check anything else.  I'll also go try and
run on a few more pieces of hardware and see if I can get it to trigger.

-- Dave

