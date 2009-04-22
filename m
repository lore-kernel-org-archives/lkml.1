Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbZDVX0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbZDVX0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 19:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbZDVX0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 19:26:39 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:54289 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751524AbZDVX0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 19:26:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoKAGdE70lMQW1W/2dsb2JhbACBT5VMuT+DdAY
Date: Wed, 22 Apr 2009 19:26:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, mark.langsdorf@amd.com, arekm@maven.pl,
       "H.  Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [patch 2/2] x86 amd fix cmpxchg read acquire barrier
Message-ID: <20090422232636.GB22718@Krystal>
References: <20090422201852.092307236@polymtl.ca> <20090422202453.829846363@polymtl.ca> <20090422215913.67c1298e@lxorguk.ukuu.org.uk> <20090422224749.GA22718@Krystal> <20090422235358.0e0cc7f3@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090422235358.0e0cc7f3@lxorguk.ukuu.org.uk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:17:06 up 53 days, 19:43,  2 users,  load average: 0.62, 0.60,
	0.55
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > Good point. I should probably configure this as "nothing" unless
> > 
> > #ifdef CONFIG_X86_64
> > #if (defined(CONFIG_GENERIC_CPU) || defined(CONFIG_MK8))
> > ...
> > #endif
> > #endif
> 
> Is the erratum only present in 64bit mode ?
> 

Hrm, from the info I gathered in the web pages linked in the patch
header (refering to Google and Solaris), nothing said it was limited to
64bit mode. You are right.

> Really this needs someone with knowledge of the erratum to characterise
> it accurately and the workarounds.

Yep, but all I can hear from AMD so far is... *crickets*

The last revision of their errata I can find has been updated in
February 2008, and does not talk about this issue.

http://support.amd.com/us/Processor_TechDocs/25759.pdf

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
