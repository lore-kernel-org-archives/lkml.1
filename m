Return-Path: <linux-kernel-owner+w=401wt.eu-S1755118AbYICV3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbYICV3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 17:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYICV3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 17:29:06 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63883 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752778AbYICV3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 17:29:05 -0400
Date: Wed, 3 Sep 2008 22:28:18 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [patch 1/2] x2apic: fix reserved APIC register accesses in
 print_local_APIC()
In-Reply-To: <20080903184552.GE14481@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.55.0809032145020.23174@cliff.in.clinika.pl>
References: <20080902234759.554038000@linux-os.sc.intel.com>
 <Pine.LNX.4.55.0809030625520.23174@cliff.in.clinika.pl>
 <20080903184552.GE14481@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Suresh Siddha wrote:

> from SDV Vol 3a Section 17.27.1
> 
>   The remote read delivery mode provided in the 82489DX and local APIC for
>   Pentium processors is not supported in the local APIC in the Pentium 4, Intel
>   Xeon, and P6 family processors.
> 
> It looks like it is not supported (officially atleast) even in APIC bus
> architectures. Only the Pentium integrated APIC seems to be the exception.

 Yeah, trust documentation and see where you'll get... ;)

> I have to probably use maxlvt check, to selectively enable this debug output
> for Pentium and !APIC_INTEGRATED check for 82489DX.

 Sounds about right.  Why couldn't have the designers simply bump up the
bloody APIC version when they introduced or removed functionality other
than LVT entries, sigh?...  It's not that they are going to run out of
numbers anytime soon.

  Maciej
