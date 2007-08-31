Return-Path: <linux-kernel-owner+w=401wt.eu-S965955AbXHaR00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965955AbXHaR00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 13:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759061AbXHaR0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 13:26:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60655 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965857AbXHaRZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 13:25:58 -0400
Message-ID: <46D84F1F.6090004@garzik.org>
Date: Fri, 31 Aug 2007 13:25:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Greg KH <greg@kroah.com>, alex@nibbles.it,
       dac@conglom-o.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Fix DAC960 driver on machines which don't support 64-bit
 DMA
References: <bug-8942-27@http.bugzilla.kernel.org/> <20070831151748.37C39108012@picon.linux-foundation.org> <20070831084259.fc2fd903.akpm@linux-foundation.org> <20070831161733.GC14130@parisc-linux.org> <20070831164746.GD14130@parisc-linux.org>
In-Reply-To: <20070831164746.GD14130@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> [Note: not tested.  I have a temporary shortage of machines with 5 volt
> PCI slots, and in any case, I think the DAC960 that I have is a V1 card]
> 
> Use PCI_DMA_* constants instead of own private definitions
> Fall back to 32-bit DMA mask if a 64-bit one fails
> 
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>

ACK


