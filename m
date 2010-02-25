Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab0BYDPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:15:21 -0500
Received: from snt0-omc3-s25.snt0.hotmail.com ([65.55.90.164]:6194 "EHLO
	snt0-omc3-s25.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758780Ab0BYDPR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:15:17 -0500
Message-ID: <SNT125-W36AFF0BF953EABAC9A0432C3400@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <tj@kernel.org>, <hancockrwd@gmail.com>
CC: <david-b@pacbell.net>, <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: RE: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA support
Date: Wed, 24 Feb 2010 19:15:16 -0800
Importance: Normal
In-Reply-To: <4B85E038.20905@kernel.org>
References: <4B7CAF95.6020306@gmail.com> <20100218052223.GA13254@kroah.com>
	 <51f3faa71002181633w1649a648s37ae73da342d0c3f@mail.gmail.com>
	 <201002192139.46189.david-b@pacbell.net>
	 <51f3faa71002192315ia84786eo1138bf9ab3417f2d@mail.gmail.com>
	 <SNT125-W457447CBE941D2703E98D0C3420@phx.gbl>
 <51f3faa71002231626q1eb62adeo660c282418f0e01@mail.gmail.com>,<4B85E038.20905@kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 25 Feb 2010 03:15:16.0700 (UTC) FILETIME=[C0D8C9C0:01CAB5C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> (following thread from the ATA side) I'm with Greg on this. USB2.0 is
> quite slow on today's standard and most 64bit machines now have IOMMU
> of some kind anyway. 

Except that unfortunately, Intel with Lynnfield and Clarkdale decided 
to do market segmentation on the VT-d feature. 
This could be done because both have an integrated northbridge.
With Lynnfield, the very common Core i5 750 CPU do not support VT-d,
but the Core i7 800 series does.
With Clarkdale, the very common Core i3 500 series do not support VT-d,
but the Core i5 600 series does, except the 661.
Not to mention that in the Core 2 generation, VT-d was available only
on Q35/Q45/X38/X48 chipsets.

Yuhong Bao
 		 	   		  
_________________________________________________________________
Hotmail: Trusted email with powerful SPAM protection.
http://clk.atdmt.com/GBL/go/201469227/direct/01/