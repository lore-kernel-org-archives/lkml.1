Return-Path: <linux-kernel-owner+w=401wt.eu-S1762121AbXEPGQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762121AbXEPGQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 02:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758588AbXEPGQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 02:16:28 -0400
Received: from www.osadl.org ([213.239.205.134]:45410 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756771AbXEPGQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 02:16:27 -0400
Subject: Re: [PATCH] x86-64 highres/dyntick support 2.6.22-rc1-v4
From: Thomas Gleixner <tglx@linutronix.de>
To: Frank Sorenson <frank@tuxrocks.com>
Cc: Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <464A9077.1010403@tuxrocks.com>
References: <1178485128.31213.98.camel@localhost.localdomain>
	 <200705142215.08910.s0348365@sms.ed.ac.uk> <1179180314.7074.36.camel@chaos>
	 <200705142342.29994.s0348365@sms.ed.ac.uk> <1179217082.7074.47.camel@chaos>
		  <4649BE4A.8000707@tuxrocks.com> <1179266013.12838.31.camel@chaos>
	 <464A403A.3050202@tuxrocks.com> <464A9077.1010403@tuxrocks.com>
Content-Type: text/plain
Date: Wed, 16 May 2007 08:20:31 +0200
Message-Id: <1179296431.12838.51.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 00:02 -0500, Frank Sorenson wrote:
> >>> highres-v3 also hung at the same point, but 2.6.21-git2-v2 worked
> >>> 2.6.22-rc1 boots without problem
> >> Can you please try the following three command line option addons ?
> > 
> >> 1: highres=off nohz=off
> >> 2: highres=off
> >> 3: nohz=off
> > 
> > All 3 hang at the same point.

Ok.

> I have tracked down the offending patch in the series to
> x86-64-convert-to-clockevents.patch

Not surprising. :)

I'm going to add some early_printks for the next version, so we can get
an idea where it gets stuck

	tglx


