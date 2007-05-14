Return-Path: <linux-kernel-owner+w=401wt.eu-S1760843AbXENWmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843AbXENWmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756318AbXENWmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:42:35 -0400
Received: from mcr-smtp-001.bulldogdsl.com ([212.158.248.7]:4028 "EHLO
	mcr-smtp-001.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756228AbXENWme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:42:34 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64 highres/dyntick support 2.6.22-rc1-v1
Date: Mon, 14 May 2007 23:42:29 +0100
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1178485128.31213.98.camel@localhost.localdomain> <200705142215.08910.s0348365@sms.ed.ac.uk> <1179180314.7074.36.camel@chaos>
In-Reply-To: <1179180314.7074.36.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705142342.29994.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 May 2007 23:05:14 Thomas Gleixner wrote:
> On Mon, 2007-05-14 at 22:15 +0100, Alistair John Strachan wrote:
> > On Monday 14 May 2007 11:26:08 Thomas Gleixner wrote:
> > > I'm pleased to announce an updated version of the x86_64
> > > highres/dyntick support patches against 2.6.22-rc1:
> >
> > [snip]
> >
> > > - Various fixups from Chris Wright
> > > - TSC calibration fix (pointed out by Alistair John Strachan)
> > >
> > > Comments, bugreports, patches are welcome as ususal
> >
> > Neither of the bugs I reported appear to be fixed.
> >
> > I took a clean git tree from the 2.6.22-rc1 tag and patched with this
> > version; my CPU MHz and dmesg counter still appear to be broken (v3 was
> > used).
>
> Sigh. /me feels stupid.
>
> Can you please apply the following patch on top and check, whether it
> fixes the problem ? Please provide the debug output, when it fails.

Doesn't fix the problem, and here is the debug:

TSC calibrated against pm_timer 8927439 9106459 179020 640810145
tsckhz: 135069550000000000 640810145 210779356
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 210779.356 MHz processor.

(Perhaps if this debug effort has to continue, we could remove some of these 
gentlemen from CC?)

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
