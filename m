Return-Path: <linux-kernel-owner+w=401wt.eu-S1765419AbXGYPFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765419AbXGYPFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 11:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758054AbXGYPFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 11:05:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38359 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757305AbXGYPFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 11:05:05 -0400
Message-ID: <46A7669C.5010104@garzik.org>
Date: Wed, 25 Jul 2007 11:05:00 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Auke Kok <auke-jan.h.kok@intel.com>, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [-mm patch] one e1000 driver should be enough for everyone
References: <20070725040304.111550f4.akpm@linux-foundation.org> <20070725133650.GB3572@stusta.de> <46A754C7.9080004@garzik.org> <20070725144615.GC3572@stusta.de>
In-Reply-To: <20070725144615.GC3572@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> I found the discussion, and Christoph's e1000e sounds like the best name 
> ("new" doesn't say whether it's a new driver for old hardware or a 
> driver for new hardware).

Yeah, I think "e1000new" is a lame name.

e1000e is good, or even e1001e if we wanted even more symmetry :)


> No problem for me, but this obviously implies that global code in the 
> new driver has to be renamed.

Yes.  A global namespace is a global namespace.


> And please ensure that they will always support distinct PCI IDs, or 
> there will be the following common pattern if both drivers support
> a card:

IIRC I think Auke said there is some minor PCI ID overlap that must be 
addressed in the transition.  Disappointing and it raises transition 
issues, but that's the way the split falls out naturally AFAICS.

	Jeff


