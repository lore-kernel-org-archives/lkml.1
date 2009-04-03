Return-Path: <linux-kernel-owner+w=401wt.eu-S1762921AbZDCKbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762921AbZDCKbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757906AbZDCKb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:31:26 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:19107 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761488AbZDCKbY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:31:24 -0400
X-BigFish: VPS-27(zz1432R98dR1805M936fKzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KHIT7W-02-JMT-01
Date: Fri, 3 Apr 2009 12:58:32 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Mark Langsdorf <mark.langsdorf@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: cacheinfo: complete L2/L3 Cache and TLB
	associativity field definitions
Message-ID: <20090403105832.GB6466@alberich.amd.com>
References: <20090402100756.GN5740@alberich.amd.com> <20090402103008.GA10828@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090402103008.GA10828@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 03 Apr 2009 10:31:09.0879 (UTC) FILETIME=[4DDD3470:01C9B447]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 12:30:08PM +0200, Ingo Molnar wrote:
> 
> * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > Impact: complete cache information for AMD CPUs
> > 
> > See "CPUID Specification" (AMD Publication #: 25481, Rev. 2.28, April 2008)
> > 
> > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > ---
> >  arch/x86/kernel/cpu/intel_cacheinfo.c |   16 ++++++++++++----
> >  1 files changed, 12 insertions(+), 4 deletions(-)
> > 
> > Please apply.
> 
> Hm, the x86/cpu topic is marked broken and blocked by another AMD 
> patch from Mark Langsdorf:
> 
>  45ca863: x86, cpu: conform L3 Cache Index Disable to Linux standards

Oops, wasn't aware that you had applied this patch and I couldn't find
it in tip/master. Now I know why.

The code seems broken. Defining k8_northbridges in a header file is the
wrong thing to do. I'll look at it.


Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


