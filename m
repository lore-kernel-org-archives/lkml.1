Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbXFXAVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbXFXAVG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 20:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbXFXAUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 20:20:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37005 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbXFXAUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 20:20:54 -0400
Subject: Re: [patch -mm 26/28] x86-64 block irq balancing for timer
From: Arjan van de Ven <arjan@infradead.org>
To: Andreas Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070624020405.78bjajayowkw000k@imap.suse.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
	 <20070623124031.301753868@inhelltoy.tec.linutronix.de>
	 <1182634040.2910.7.camel@laptopd505.fenrus.org>
	 <20070624020405.78bjajayowkw000k@imap.suse.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Sat, 23 Jun 2007 18:20:14 -0700
Message-Id: <1182648015.2626.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-24 at 02:04 +0200, Andreas Kleen wrote:
> Am Sat 23 Jun 2007 11:27:20 PM CEST schrieb Arjan van de Ven  
> <arjan@infradead.org>:
> 
> > On Sat, 2007-06-23 at 13:32 +0000, Thomas Gleixner wrote:
> >> plain text document attachment
> >> (x86-64-clockevents-irq-balancing.patch)
> >> From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
> >>
> >> Disable irq balancing on IRQ0.
> >
> >
> > this patch is missing some rationale....
> 
> Several SIS chipsets lock up when you try to change affinity of IRQ #0

so we're protecting root against himself.. fair enough.
probably wants a comment in the code 
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

