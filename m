Return-Path: <linux-kernel-owner+w=401wt.eu-S1758281AbYD0I31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbYD0I31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 04:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbYD0I3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 04:29:17 -0400
Received: from trillian.zoopnet.de ([85.214.111.199]:47403 "EHLO
	trillian.zoopnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbYD0I3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 04:29:14 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Apr 2008 04:29:14 EDT
Message-ID: <48143952.2000609@zoopnet.de>
Date: Sun, 27 Apr 2008 10:29:06 +0200
From: Mika Fischer <mika.fischer@zoopnet.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, balajirrao@gmail.com
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
References: <200801192045.17291.yinghai.lu@sun.com>	 <200801202256.48365.yinghai.lu@sun.com>	 <20080122165125.GA17992@elte.hu>	 <200801221623.20861.yinghai.lu@sun.com>	 <20080426035614.a30afb17.akpm@linux-foundation.org> <86802c440804261822p4df226det4c4323fdee91781c@mail.gmail.com>
In-Reply-To: <86802c440804261822p4df226det4c4323fdee91781c@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>  reg00: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
>>  reg01: base=0x00000000 ( 0MB), size=4096MB: write-back, count=1
>>  reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
>>  reg03: base=0xbf700000 (3063MB), size= 1MB: uncachable, count=1
>>  reg04: base=0xbf800000 (3064MB), size= 8MB: uncachable, count=1
>>
>>  which screws up the X server's attempt to map the video memory at
>>  0xd0000000.
> 
> the BIOS should have set memhole to 2048MB or 2560M instead of 1033MB
> 
> good mtrr should
> 
>>  reg00: base=0x00000000 (0MB), size=2048MB: write-back, count=1
>>  reg01: base=0x100000000 (4096MB), size=2048MB: write-back, count=1
> 
> or
> 
>>  reg00: base=0x00000000 (0MB), size=2048MB: write-back, count=1
>>  reg01: base=0x80000000 (2048MB), size=512MB: write-back, count=1
>>  reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
>>  reg03: base=0x140000000 (4096MB), size=512MB: write-back, count=1
> 
> so please talk to your HW esp CPU vendor to fix the BIOS problem.

This is a Core 2 Duo CPU, so my CPU vendor is Intel. I assume that the
relevant people are already reading this, no?

I'm not sure what I'm supposed to do? Write an Email to Intel support,
referencing this thread? Doesn't anyone here already know the right
people at Intel who could actually do something about this. I think that
would be more useful since I doubt an email to Intel support would reach
those people...

Regards,
 Mika

