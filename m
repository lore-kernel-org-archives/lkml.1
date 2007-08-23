Return-Path: <linux-kernel-owner+w=401wt.eu-S1765036AbXHWU4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765036AbXHWU4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 16:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbXHWU4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 16:56:18 -0400
Received: from www.osadl.org ([213.239.205.134]:53252 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756049AbXHWU4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 16:56:17 -0400
Subject: Re: x86_64-dynticks-disable-hpet_id_legsup-hpets.patch hangs the
	system
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ego@in.ibm.com, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       johnstul@us.ibm.com
In-Reply-To: <20070823134726.8f2c508a.akpm@linux-foundation.org>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	 <20070823112423.GA26084@in.ibm.com>
	 <20070823134726.8f2c508a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 23 Aug 2007 22:56:14 +0200
Message-Id: <1187902574.15576.10.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-23 at 13:47 -0700, Andrew Morton wrote:
> > Any particular reason for this patch [There is no changelog :-)]? 
> > Without this patch the mm-kernel seems to behave just fine for me.
> 
> Oh damn.  That patch is required to prevent a boot-time div-by-zero
> on my old nocona machine.

That patch was necessary due to a bug in the hpet code, which is
resolved for quite a while (hopefully). It was not a divide by zero, it
was some attempt to map stuff before the mm was initialized, IIRC.

> I have a new set of x86_64-dynticks patches from Thomas to look at
> so I guess it's reset-and-start-again time on that front.

Yep. I dropped that patch in the series.

	tglx


