Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbXEXGSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbXEXGSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 02:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbXEXGSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 02:18:30 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40995 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430AbXEXGSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 02:18:30 -0400
Message-ID: <46552E2E.5000404@pobox.com>
Date: Thu, 24 May 2007 02:18:22 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Olivier Galibert <galibert@pobox.com>,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
References: <4635510D.4060103@shaw.ca> <20070523222443.GA39776@dspnet.fr.eu.org> <alpine.LFD.0.98.0705231536510.3890@woody.linux-foundation.org> <200705231555.07683.jbarnes@virtuousgeek.org> <alpine.LFD.0.98.0705231709220.3890@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705231709220.3890@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Things like: A20 gate, 15-16MB holes, i387 FP exception on irq 13 are 
> totally pointless in this day and age. Things like the DMA controller are 
> getting there, along with PS/2 keyboard support.


The latest Intel chipset I have (ICH9) is legacy free:  no serial port 
and no PS/2 ports.  I had to disable the Linux PS2 input drivers 
completely, just to get the thing to boot.

Whee, "progress".   :)

	Jeff, digging out that USB debug cable cuz there's no serial


