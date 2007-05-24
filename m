Return-Path: <linux-kernel-owner+w=401wt.eu-S1762172AbXEXDUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762172AbXEXDUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 23:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758230AbXEXDT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 23:19:56 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758167AbXEXDT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 23:19:56 -0400
Date: Wed, 23 May 2007 20:18:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Olivier Galibert <galibert@pobox.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
In-Reply-To: <200705231959.26963.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.0.98.0705232016350.3890@woody.linux-foundation.org>
References: <4635510D.4060103@shaw.ca> <200705231555.07683.jbarnes@virtuousgeek.org>
 <alpine.LFD.0.98.0705231709220.3890@woody.linux-foundation.org>
 <200705231959.26963.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 May 2007, Jesse Barnes wrote:
> 
> So what do you think?  You ok with enabling mmconfig if it's available as long 
> as we use type 1 accesses for non-extended stuff?  If so, I think the patches 
> are pretty much ready...

Sure. I think mmconfig is perfectly sane if it falls back to conf1 
accesses for legacy stuff..

And I also actually think that your patch to disable MMIO/PIO when testing 
the BAR size is fine - I just think that it should likely only be done for 
non-bridge devices (or at least non-host-bridge).

		Linus
