Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbZEHQwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbZEHQwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 12:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbZEHQwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 12:52:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36741 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbZEHQwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 12:52:36 -0400
Message-ID: <4A04633C.5090305@zytor.com>
Date: Fri, 08 May 2009 09:52:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: improve e820_search_gap()
References: <4A0199B8.76EA.0078.0@novell.com> <4A03BC1A.9060605@zytor.com> <4A03F016.76EA.0078.0@novell.com>
In-Reply-To: <4A03F016.76EA.0078.0@novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>
>> So blindly locate it somewhere else?  How is that inherently better?
>> Wouldn't a machine with hotplug memory (which doesn't bother advertising
>> that fact so we can reserve the address space) be just as likely to use
>> a sparse memory space, since one can hardly expect the hardware to pack
>> the space (packing in hardware is why PCs generally have a
>> mostly-contiguous RAM space) when the memory is hotplugged?
> 
> Why blindly? Aren't hotpluggable memory ranges supposed to be reserved
> in the E820 map?
> 

That's was my reaction too... so I guess I'm misreading the patch.
Could you perhaps add a bit more to the description, specifically of
what policy your patch implements.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

