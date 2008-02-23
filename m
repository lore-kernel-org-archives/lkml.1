Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYBWMgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYBWMgy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 07:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYBWMgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 07:36:47 -0500
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:54050 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753030AbYBWMgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 07:36:46 -0500
Date: Sat, 23 Feb 2008 13:37:08 +0100
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Subject: Re: [Xen-devel] [PATCH] let XEN depend on PAE
In-reply-to: <47BF266F.5020806@nets.rwth-aachen.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>
Message-id: <47C01374.5030608@nets.rwth-aachen.de>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7BIT
X-IronPort-AV: E=Sophos;i="4.25,394,1199660400";   d="scan'208";a="51793165"
References: <47BEAB48.7050900@nets.rwth-aachen.de> <47BEFA4C.6030400@goop.org>
 <47BEFE55.7020703@nets.rwth-aachen.de> <47BF1B8F.5090701@goop.org>
 <47BF266F.5020806@nets.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Hannemann wrote:
> Jeremy Fitzhardinge wrote:
>> Arnd Hannemann wrote:
>>> This is with 2.6.24.2, but latest-git looks the same:
>>> I also tried with 2.6.23 which crashes instantly, without any output
>>> of the guest.
>>>   
>> I'm not too surprised.  Non-PAE Xen is a bit of a rarity, and it only
>> gets tested rarely.  Chris Wright did spend some time on it a while ago,
>> but I don't know that its had any real attention since.  I've been
>> making sure non-PAE compiles, but I've been lax about testing it.
>> This is the first usermode exec, I guess?  The backtrace is a bit odd;
>> I've never seen a problem in move_page_tables before.
> 
> Yes its trying to execute the first script in initramfs, I also tried with initramdisk
> and got a similar error. (move_page_tables also involved)
> 
>> Does "xm dmesg" tell you what Xen is complaining about?  You may need to
>> compile with debug=y in Config.mk.
> 
> (XEN) mm.c:645:d44 Non-privileged (44) attempt to map I/O space 00000000
> 
> I will recompile with debug=y and post the output.

I recompiled with debug=y but no more information than above message...

[snip]

Arnd

