Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbXFOMGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbXFOMGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbXFOMGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:06:00 -0400
Received: from www.osadl.org ([213.239.205.134]:37004 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752544AbXFOMF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:05:59 -0400
Subject: Re: Jinxed VAIO wreckage - current state of affairs
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>
In-Reply-To: <20070609200827.635fec79.akpm@linux-foundation.org>
References: <1181418873.4404.402.camel@chaos>
	 <200706092259.50694.rjw@sisk.pl>
	 <20070609200827.635fec79.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 14:05:57 +0200
Message-Id: <1181909157.8176.342.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-09 at 20:08 -0700, Andrew Morton wrote:
> On Sat, 9 Jun 2007 22:59:49 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Hmm, how's 2.6.22-rc4-mm2 doing on the Vaio?
> 
> People would have heard if it was busted ;)

Just found a brown paperbag bug in the resume patch logic. Sigh, I was
staring at that code for month without noticing.

Andrew,

can you please test

http://www.tglx.de/projects/hrtimers/2.6.22-rc4/patch-2.6.22-rc4-hrt9.patch

Thanks,

	tglx



