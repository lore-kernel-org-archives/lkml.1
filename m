Return-Path: <linux-kernel-owner+w=401wt.eu-S2992980AbXDDQEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992980AbXDDQEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992984AbXDDQEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:04:48 -0400
Received: from gw.goop.org ([64.81.55.164]:57991 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992980AbXDDQEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:04:47 -0400
Message-ID: <4613CC8E.7020202@goop.org>
Date: Wed, 04 Apr 2007 09:04:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 04/17] Add pagetable accessors to pack and unpack pagetable
 entries
References: <20070402055652.610711908@goop.org> <200704041347.42822.ak@suse.de> <4613C828.2030604@goop.org> <200704041756.35016.ak@suse.de>
In-Reply-To: <200704041756.35016.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> I was talking about the patched case. It seemed to be a little slower
> too, but in theory it shouldn't have been, no? 

Oh, the .25 vs .26?  That's definitely noise; on other runs I see no
difference:

paravirt, patched, busy machine
ezr       Linux 2.6.21- 1000 0.25 0.52 31.3 34.4 12.7 1.02 5.44 743. 1578 4582
ezr       Linux 2.6.21- 1000 0.25 0.53 31.4 34.2 12.1 1.02 5.27 736. 1594 4806
ezr       Linux 2.6.21- 1000 0.25 0.52 31.5 34.4 14.3 1.02 5.49 736. 1587 4601

(I didn't use this result because I did it on a fairly busy machine, but
the best-case numbers are actually somewhat better than the run on a
completely quiet machine.)


    J
