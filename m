Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbZDVKQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbZDVKQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 06:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbZDVKQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 06:16:22 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:51861
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752406AbZDVKQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 06:16:22 -0400
X-BigFish: VPS-35(zz1432R62a3L98dR936eQ1805Mzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KIHZ6R-03-8OE-01
Date: Wed, 22 Apr 2009 12:16:01 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       linux-kernel@vger.kernel.org,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
Message-ID: <20090422101600.GL3226@erda.amd.com>
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com> <20090422092259.GC18226@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090422092259.GC18226@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 22 Apr 2009 10:16:01.0846 (UTC) FILETIME=[567B9D60:01C9C333]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.04.09 11:22:59, Ingo Molnar wrote:
> 
> * Huang Ying <ying.huang@intel.com> wrote:
> 
> > Re-implement MCE log ring buffer as per-CPU ring buffer for better 
> > scalability. Basic design is as follow:
> 
> Before changing anything substantial in the MCE code it would be 
> necessary to clean up and then unify the 32-bit and 64-bit side of 
> the MCE code first. (Which essentially means extending the 
> 64-bit-only code to 32-bit)

You may also want to consider to use the in-kernel ring_buffer api
(include/linux/ring_buffer.h).

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

