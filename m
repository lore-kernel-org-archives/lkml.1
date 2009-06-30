Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbZF3Ger@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbZF3Ger (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 02:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbZF3Gej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 02:34:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36760 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbZF3Gej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 02:34:39 -0400
Message-ID: <4A49B1C6.9040900@kernel.org>
Date: Mon, 29 Jun 2009 23:33:42 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Marc Aurele La France <root@ualberta.ca>,
       "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
       stable@kernel.org, Research.Support@ualberta.ca,
       linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH] x86, setup (2.6.30-stable) fix 80x34 and	80x60
 console modes
References: <alpine.BSO.1.10.0906291746410.14658@fanir.ucs.ualberta.ca> <4A496A0C.809@kernel.org> <20090630034822.GC12373@kroah.com>
In-Reply-To: <20090630034822.GC12373@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Jun 29, 2009 at 06:27:40PM -0700, H. Peter Anvin wrote:
>> Marc Aurele La France wrote:
>>> As coded, most INT10 calls in video-vga.c allow the compiler to assume EAX 
>>> remains unchanged across them, which is not always the case.  This 
>>> triggers an optimisation issue that causes vga_set_vertical_end() to be 
>>> called with an incorrect number of scanlines.  Fix this by beefing up the 
>>> asm constraints on these calls.
>>>
>>> Reported-by: Marc Aurele La France <tsi@xfree86.org>
>>> Signed-off-by: Marc Aurele La France <tsi@xfree86.org>
>>> Acked-by: H. Peter Anvin <hpa@zytor.com>
>> Note: this is not in upstream since upstream is not affected due to the
>> new "BIOS glovebox" subsystem.
> 
> So it is a ".30 only" type patch?  Any older kernel versions affected?
> 

Yes, all the way back to .23 or something like that.

	-hpa
