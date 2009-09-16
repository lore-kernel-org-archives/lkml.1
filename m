Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbZIPU4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbZIPU4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 16:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbZIPU4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 16:56:09 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:40165
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752473AbZIPU4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 16:56:08 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz62a3L1432R98dN936eM4015Lzz1202hzzz32i203h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KQ30SS-01-540-02
X-M-MSG: 
Date: Wed, 16 Sep 2009 22:54:52 +0200
From: Robert Richter <robert.richter@amd.com>
To: Steven Rostedt <srostedt@redhat.com>
CC: Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Stephane Eranian <eranian@googlemail.com>
Subject: Re: [PATCH] Fix oprofile regression: select RING_BUFFER_ALLOW_SWAP
Message-ID: <20090916205452.GL24322@erda.amd.com>
References: <200909162156.49239.borntraeger@de.ibm.com>
 <1253131890.2964.168.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1253131890.2964.168.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 16 Sep 2009 20:54:52.0842 (UTC) FILETIME=[F042B0A0:01CA370F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.09.09 16:11:30, Steven Rostedt wrote:
> On Wed, 2009-09-16 at 21:56 +0200, Christian Borntraeger wrote:
> > commit 85bac32c4a52c592b857f2c360cc5ec93a097d70                                                                                                                             
> >     ring-buffer: only enable ring_buffer_swap_cpu when needed
> > broke oprofile (at least on s390, but likely on all platforms).
> > 
> > this patch lets oprofile select RING_BUFER_ALLOW_SWAP to make 
> > ring_buffer_swap_cpu usable for oprofile.
> 
> Thanks, I'll apply this for the 32 queue.

Thanks Christian,

I was just debugging it for x86 too and narrowed it to the
tracing-core merge already.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

