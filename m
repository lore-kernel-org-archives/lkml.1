Return-Path: <linux-kernel-owner+w=401wt.eu-S1759379AbXEWUq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379AbXEWUq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 16:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756520AbXEWUqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 16:46:48 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755509AbXEWUqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 16:46:47 -0400
Date: Wed, 23 May 2007 13:45:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Robert Hancock <hancockr@shaw.ca>,
       Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
In-Reply-To: <20070523213810.00d498c9@the-village.bc.nu>
Message-ID: <alpine.LFD.0.98.0705231344060.3890@woody.linux-foundation.org>
References: <4635510D.4060103@shaw.ca> <200705221738.09571.jbarnes@virtuousgeek.org>
 <46539378.6000508@shaw.ca> <200705231152.57796.jbarnes@virtuousgeek.org>
 <alpine.LFD.0.98.0705231257050.3890@woody.linux-foundation.org>
 <20070523213810.00d498c9@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 May 2007, Alan Cox wrote:
>
> > Well, the thing is, I'm pretty sure there is at least one northbridge that 
> > stops memory accesses from the CPU when you turn off the MEM bit on it. 
> > Oops, you just killed the machine.
> 
> CS5520. But it doesn't have 64bit or PCI Express.

That patch does it for _all_ PCI probing. So it would turn any machine 
using that northbridge into a brick.

		Linus
