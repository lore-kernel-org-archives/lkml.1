Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbXEOVto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbXEOVto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 17:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbXEOVth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 17:49:37 -0400
Received: from www.osadl.org ([213.239.205.134]:60311 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755720AbXEOVth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 17:49:37 -0400
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
In-Reply-To: <4649BE4A.8000707@tuxrocks.com>
References: <1178485128.31213.98.camel@localhost.localdomain>
	 <200705142215.08910.s0348365@sms.ed.ac.uk> <1179180314.7074.36.camel@chaos>
	 <200705142342.29994.s0348365@sms.ed.ac.uk> <1179217082.7074.47.camel@chaos>
	  <4649BE4A.8000707@tuxrocks.com>
Content-Type: text/plain
Date: Tue, 15 May 2007 23:53:33 +0200
Message-Id: <1179266013.12838.31.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frank,

On Tue, 2007-05-15 at 09:06 -0500, Frank Sorenson wrote:
> Hangs at boot here:
> 	Kernel alive
> 	Kernel direct mapping tables up to 100000000 @ 8000-d000
> (and that's it)
> 
> This is a Dell Inspiron E1705 with a Core 2 Duo 2.16GHz
> 
> highres-v3 also hung at the same point, but 2.6.21-git2-v2 worked
> 2.6.22-rc1 boots without problem

Can you please try the following three command line option addons ?

1: highres=off nohz=off
2: highres=off
3: nohz=off

Thanks,

	tglx


