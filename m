Return-Path: <linux-kernel-owner+w=401wt.eu-S933383AbXCOCbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383AbXCOCbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 22:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933388AbXCOCbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 22:31:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:44395 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933383AbXCOCbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 22:31:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,286,1170662400"; 
   d="scan'208"; a="212857118:sNHT23067996"
Date: Wed, 14 Mar 2007 19:31:03 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
Subject: Re: RSDL v0.30 cpu scheduler for mainline kernels
Message-ID: <20070315023102.GL30596@linux-os.sc.intel.com>
References: <200703121058.11966.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703121058.11966.kernel@kolivas.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con,

On Mon, Mar 12, 2007 at 10:58:11AM +1100, Con Kolivas wrote:
> There are updated patches for 2.6.20, 2.6.20.2, 2.6.21-rc3 and 2.6.21-rc3-mm2 
> to bring RSDL up to version 0.30 for download here:

I tried this on a Core 2 Quad cpu system(system has 4 cores on a single
package). When I run SPECjbb2000 with number of threads varying from 1-8,
I see ~4.5% perf regression with RSDL (compared to native 2.6.21-rc3) in
the 8 threads case. This I think, is coming from increased number of
context switches, when we have more than one thread(at same user priority) on
the same logical cpu.

Just to see the % increase in number of context switches, I ran 8 infinite
loops (simple while(1); 's) and with 2.6.21-rc3 I see ~70 context switches
every second, whereas with RSDL I see ~530 context switches.

thanks,
suresh
