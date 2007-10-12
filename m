Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbXJKBDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbXJKBDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 21:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757232AbXJKBDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 21:03:39 -0400
Received: from smtp113.sbc.mail.re2.yahoo.com ([68.142.229.92]:45926 "HELO
	smtp113.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757225AbXJKBDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 21:03:38 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Oct 2007 21:03:38 EDT
X-YMail-OSG: IbGU7lgVM1nq7R3mP3Ri725_BITnnfRYDS1F8b1yptVx94BD_u4pBnajNFjsJe4G464DmNbv3w--
Message-ID: <470EC64C.10402@cse.wustl.edu>
Date: Thu, 11 Oct 2007 19:56:44 -0500
From: Berkley Shands <berkley@cse.wustl.edu>
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23 spinlock hang in kswapd under heavy disk write loads
References: <20071010153332.71479CECBD@tamarack.cse.wustl.edu> <200710101531.26944.nickpiggin@yahoo.com.au>
In-Reply-To: <200710101531.26944.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

100% reproducible on the two motherboards in question.
Does not happen on any other motherboard I have in my possession
(not tyan, not uniwide, not socket 940...)

No errors, no dmesg, nothing with debug_spinlock set.
<sysrq> shows lots (when it works), but by then too many things are
locked up to be of much use. I can get into KDB and look around
(2.6.22 for kdb - it hangs there too). Even access to the local disk is 
blocked.
Processes in core and running remain there (iostat, top, ...).
I personally think the bios are suspect on the PCIe, as symptoms change with
the bios rev. I did a major paper on SAS performance with one H8DMi,
but it got a bios rev, and now crashes. Missed interrupt? APIC sending
an interrupt to multiple cpus? I don't know.

Tell me what to look at, and I can get you the info. It usually takes 20 
seconds
to go bang, using either the LSI8888ELP or the rocket raid 2340. Other 
controllers
are too slow. 2.6.20 does not lock up. It is also 200MB/Sec slower in 
writing :-)

thanks for the response.

berkley


