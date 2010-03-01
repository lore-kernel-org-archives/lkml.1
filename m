Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab0CABbl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 20:31:41 -0500
Received: from snt0-omc2-s22.snt0.hotmail.com ([65.55.90.97]:18880 "EHLO
	snt0-omc2-s22.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751948Ab0CABbk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 20:31:40 -0500
Message-ID: <SNT125-W530B92A00FA8AFB846085EC33C0@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, <mingo@redhat.com>,
       <linux-kernel@vger.kernel.org>
Subject: RE: Ubuntu 32-bit, 32-bit PAE, 64-bit Kernel Benchmarks
Date: Sun, 28 Feb 2010 17:31:39 -0800
Importance: Normal
In-Reply-To: <4B511B12.6010208@zytor.com>
References: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl>,<4B511B12.6010208@zytor.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 01 Mar 2010 01:31:39.0713 (UTC) FILETIME=[F0E2DB10:01CAB8DE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>> Given that Linus was once talking about the performance penalties of PAE and HIGHMEM64G, perhaps you'd find these benchmarks done by Phoronix of interest:
>> http://www.phoronix.com/scan.php?page=article&item=ubuntu_32_pae
>>
>
> The big difference isn't between HIGHMEM4G (no PAE) and HIGHMEM64G
> (PAE), it's between HIGHMEM and !HIGHMEM. That cutoff is ~892 MB for a
> stock 32-bit kernel.
BTW, Linus posted this about HIGHMEM and PAE:
http://www.realworldtech.com/forums/index.cfm?action=detail&id=78966&threadid=78766&roomid=2
A few corrections though. HIMEM.SYS was never about memory windowing, EMS was.
The way the 286 could access 16MB of memory was plain old segmentation, just in a different way than EMS did.
And the main issue with PAE in Windows was driver issues, I think, which is why when they enabled PAE to get the NX bit, they limited physical address space to 32-bit on client versions of Windows.

Yuhong Bao
 		 	   		  
_________________________________________________________________
Hotmail: Powerful Free email with security by Microsoft.
http://clk.atdmt.com/GBL/go/201469230/direct/01/