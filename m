Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbZDMUQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbZDMUQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 16:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbZDMUQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 16:16:01 -0400
Received: from relay2.sgi.com ([192.48.179.30]:54396 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750935AbZDMUQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 16:16:00 -0400
Date: Mon, 13 Apr 2009 15:15:58 -0500
From: Robin Holt <holt@sgi.com>
To: Matt Carlson <mcarlson@broadcom.com>
Cc: Robin Holt <holt@sgi.com>, Michael Chan <mchan@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Li <benli@broadcom.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.30-rc1 tg3 endian issues with MAC addresses on
	BCM5701. Bisected.
Message-ID: <20090413201558.GK10768@sgi.com>
References: <20090408053721.GE10768@sgi.com> <C27F8246C663564A84BB7AB343977242176F6BF106@IRVEXCHCCR01.corp.ad.broadcom.com> <20090408062559.GF10768@sgi.com> <20090408071204.GG10768@sgi.com> <20090413175724.GA11076@xw6200.broadcom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413175724.GA11076@xw6200.broadcom.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 10:57:24AM -0700, Matt Carlson wrote:
> Thank you for doing this bisection Robin.  This, and the data you
> provided in your previous email is really helpful.  Unfortunately, they
> raise more questions than answers.
> 
> I reviewed this patch again, and it still looks correct to me.  It
> should be one big behavioral no-op.  Obviously something is wrong, but
> I'm not seeing the root cause at the moment.  I need to think about this
> some more.

If you want me to build test kernels with debug printk's, etc.  Let me
know.  I will be working that issue on the side, so my responses may be
slightly delayed.  I have access to many tests machines that exhibit
this problem.

The problem seems to affect BCM5701 based systems only.  BCM5704 have
the correct MAC addresses.  Nearly all of our SGI Altix 3700/4700
machines have the BCM5701 adapters on their base I/O board.

Thanks,
Robin
