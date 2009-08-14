Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbZHNRgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbZHNRgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 13:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbZHNRgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 13:36:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:1381 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756226AbZHNRgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 13:36:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,381,1246863600"; 
   d="scan'208";a="541430272"
Subject: Re: [patch] clockevents_notify() need to be called with irq's
 enabled
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Brown, Len" <len.brown@intel.com>
In-Reply-To: <alpine.LFD.2.00.0908141025290.1283@localhost.localdomain>
References: <1250203681.27006.10842.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0908140753370.1283@localhost.localdomain>
	 <1250234778.2965.8.camel@sbs-t61>
	 <alpine.LFD.2.00.0908141025290.1283@localhost.localdomain>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 14 Aug 2009 10:39:53 -0700
Message-Id: <1250271593.3077.8.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-14 at 01:28 -0700, Thomas Gleixner wrote:
> On Fri, 14 Aug 2009, Suresh Siddha wrote:
> 
> > We didn't go that route because of the smp_call_function() in the cpu
> > hotplug code. So we can't disable interrupts in that path.
> 
> Hmm, that's the tick_broadcast_on_off() stuff, right ?

Yes Thomas.

