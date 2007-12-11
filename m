Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbXLKF7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbXLKF7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 00:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbXLKF7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 00:59:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35247 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbXLKF7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 00:59:05 -0500
Message-ID: <475E26FD.7030104@zytor.com>
Date: Mon, 10 Dec 2007 21:58:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "David P. Reed" <dpreed@reed.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com>	<p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<475AEF8E.5040906@reed.com> <20071208202631.14b0f768@the-village.bc.nu>
In-Reply-To: <20071208202631.14b0f768@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> In any case, my machine does not have an ISA bus.  Why should it?  It's 
>> a laptop!
> 
> Yes it does. The branding spec said "No ISA bus" so it was renamed "LPC"
> and hidden internally, but its alive and well.
> 

Well that, plus it was serialized and uses PCI electricals and timing, 
hence the LPC (Low Pin Count) moniker.  Its performance is pretty much 
exactly ISA, though, and unlike PCI it provides full support for all 
legacy ISA features like slave DMA.

	-hpa
