Return-Path: <linux-kernel-owner+w=401wt.eu-S1762664AbXEUQ3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762664AbXEUQ3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756049AbXEUQ3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:29:05 -0400
Received: from nwk-ea-fw-1.sun.com ([192.18.42.249]:62195 "EHLO
	nwk-ea-fw-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003AbXEUQ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:29:04 -0400
Date: Mon, 21 May 2007 09:27:26 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH]serial: make early_uart to use early_prarm instead of
 console_initcall
In-reply-to: <20070521104221.GU2012@bingen.suse.de>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Gerd Hoffmann <kraxel@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <4651C86E.2040901@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <200705181900.17101.yinghai.lu@sun.com>
 <20070520202332.145d93a6.akpm@linux-foundation.org>
 <20070521104221.GU2012@bingen.suse.de>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> It is someone's reimplemention of earlyprintk= for another architecture
> that happens to mostly work on x86 too because the code is not ifdeffed. 
> I don't think it makes much sense on x86 though because earlyprintk exists.

Andi,

Bjorn refer to your early_printk to implement early_uart for ia64 platform. code is almost identical, but it could take
mmio,0xfe00000,9600n8 etc. or say mmio type serial card.

YH
