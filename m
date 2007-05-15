Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbXEOXYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbXEOXYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 19:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758816AbXEOXYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 19:24:04 -0400
Received: from mcr-smtp-001.bulldogdsl.com ([212.158.248.7]:1357 "EHLO
	mcr-smtp-001.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758707AbXEOXYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 19:24:01 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64 highres/dyntick support 2.6.22-rc1-v4
Date: Wed, 16 May 2007 00:23:55 +0100
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1178485128.31213.98.camel@localhost.localdomain> <200705142342.29994.s0348365@sms.ed.ac.uk> <1179217082.7074.47.camel@chaos>
In-Reply-To: <1179217082.7074.47.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705160023.55899.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 May 2007 09:18:02 Thomas Gleixner wrote:
> I've uploaded a new version of the x86_64 highres/dyntick patches:
>
> http://www.tglx.de/projects/hrtimers/2.6.22-rc1/linux-2.6.22-rc1-x86_64-hig
>hres-v4.patch
>
> Broken out version:
>
> http://www.tglx.de/projects/hrtimers/2.6.22-rc1/linux-2.6.22-rc1-x86_64-hig
>hres-v4.patches.tar.bz2
>
> Changes since last version:
>
> - TSC calibration against PM-Timer

Working fine now, thanks a lot. Great latencies on usleep() now too, just what 
I was looking for.

(BTW, with HRT (but not NO_HZ), does the HZ value have any effect on usleep() 
(and friends) latencies?)

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
