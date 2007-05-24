Return-Path: <linux-kernel-owner+w=401wt.eu-S1759625AbXEXC7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbXEXC7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 22:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757264AbXEXC7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 22:59:47 -0400
Received: from outbound-mail-78.bluehost.com ([69.89.22.27]:52730 "HELO
	outbound-mail-78.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756667AbXEXC7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 22:59:46 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Wed, 23 May 2007 19:59:26 -0700
User-Agent: KMail/1.9.6
Cc: Olivier Galibert <galibert@pobox.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca> <200705231555.07683.jbarnes@virtuousgeek.org> <alpine.LFD.0.98.0705231709220.3890@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705231709220.3890@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231959.26963.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 23, 2007 5:21:13 Linus Torvalds wrote:
> On Wed, 23 May 2007, Jesse Barnes wrote:
> > After I sent my last message I realized the same thing... though I
> > occasionally hear people talk about removing it (I seriously doubt that
> > will ever happen).  I don't even think there's a way to disable type 1
> > config access on Intel chipsets...
>
> Considering that the chipsets still have support for features that
> *really* aren't used (and haven't been used in over a decade), I doubt the
> conf1 thing is going away any time soon.
>
> Things like: A20 gate, 15-16MB holes, i387 FP exception on irq 13 are
> totally pointless in this day and age. Things like the DMA controller are
> getting there, along with PS/2 keyboard support.
>
> So there's a lot of things that are likely to be removed before conf1
> accesses would. Removing CONF1 accesses would break every single current
> OS, they'll do that ten years from now at the earliest.

So what do you think?  You ok with enabling mmconfig if it's available as long 
as we use type 1 accesses for non-extended stuff?  If so, I think the patches 
are pretty much ready...

Thanks,
Jesse
