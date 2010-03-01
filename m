Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab0CABi1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 20:38:27 -0500
Received: from snt0-omc2-s10.snt0.hotmail.com ([65.55.90.85]:31013 "EHLO
	snt0-omc2-s10.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752929Ab0CABi0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 20:38:26 -0500
Message-ID: <SNT125-W5408CB144BBE5A15619797C33C0@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, <mingo@redhat.com>,
       <linux-kernel@vger.kernel.org>
Subject: RE: Ubuntu 32-bit, 32-bit PAE, 64-bit Kernel Benchmarks
Date: Sun, 28 Feb 2010 17:38:26 -0800
Importance: Normal
In-Reply-To: <4B511B12.6010208@zytor.com>
References: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl>,<4B511B12.6010208@zytor.com>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 01 Mar 2010 01:38:26.0139 (UTC) FILETIME=[E3228AB0:01CAB8DF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The way the 286 could access 16MB of memory was plain old segmentation, just in a different way than EMS did.
I mean different from the way 8086/8088 did, which was that the selector's base address was always the selector value itself shifted by 4 bit to get a 20-bit base address. The 286 and later supported this in their real mode (and virtual 8086 mode in 386 and later) for compatibility. But in their protected mode, the selector was looked up in the GDT/LDT to get the base address and length of the segment as well as protection attributes.

Yuhong Bao
 		 	   		  
_________________________________________________________________
Hotmail: Trusted email with Microsoft’s powerful SPAM protection.
http://clk.atdmt.com/GBL/go/201469226/direct/01/