Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbXEWVmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbXEWVmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 17:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbXEWVmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 17:42:23 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37443 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293AbXEWVmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 17:42:23 -0400
Message-ID: <4654B530.2050705@pobox.com>
Date: Wed, 23 May 2007 17:42:08 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>,
       Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
References: <4635510D.4060103@shaw.ca> <4654AD91.1030808@pobox.com> <20070523223513.7dbb89f4@the-village.bc.nu> <200705231438.03910.jbarnes@virtuousgeek.org>
In-Reply-To: <200705231438.03910.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Wednesday, May 23, 2007 2:35 pm Alan Cox wrote:
>>> One of the reasons why hardware vendors want to move away from
>>> traditional accesses is to be able to use the larger config space
>>> in PCI-Express, rather than being locked into the 256-byte legacy
>>> PCI config space.
>> Mostly for treacherous computing extensions where subsets of the
>> config space can only be accessed by signed machines blessed by your
>> favourite movie company and video card vendor...
> 
> I hate "trusted" platform garbage as much as the next guy 
> (where "trusted" means the actual user can't trust it, just the 
> seller), but I think there are legitimate uses of extended space as 
> well, PCIe AER uses it iirc, so don't dismiss it on those grounds. :)

Indeed.  It's just a register space.  Assuming one register space is 
"more evil" than another, simply because it is bigger, is.. well.. silly.

	Jeff



