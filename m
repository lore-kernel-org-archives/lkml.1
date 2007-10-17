Return-Path: <linux-kernel-owner+w=401wt.eu-S1760202AbXJQOdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202AbXJQOdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 10:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbXJQOdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 10:33:38 -0400
Received: from rtr.ca ([76.10.145.34]:4773 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760577AbXJQOdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 10:33:37 -0400
Message-ID: <47161D3E.3030104@rtr.ca>
Date: Wed, 17 Oct 2007 10:33:34 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
Cc: Theodore Tso <tytso@mit.edu>, pcihpd-discuss@lists.sourceforge.net,
       Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [Pcihpd-discuss] [PATCH 1/4] Fix PCIe hotplug for non-ACPI ExpressCard
 slots (version 2)
References: <471509FE.7080505@rtr.ca> <47151191.40406@rtr.ca> <20071016130757.ed2f2ce4.kristen.c.accardi@intel.com> <4715217D.2000803@rtr.ca> <20071016214143.GC21815@kroah.com> <471533AF.60100@rtr.ca> <47156B14.2080608@rtr.ca> <47156B40.4060006@rtr.ca> <20071017032907.GA16728@parisc-linux.org> <47160984.7030308@rtr.ca> <20071017140224.GD16728@parisc-linux.org>
In-Reply-To: <20071017140224.GD16728@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Wed, Oct 17, 2007 at 09:09:24AM -0400, Mark Lord wrote:
>
>> ..
>>>> -	temp_word = (temp_word & ~intr_enable) | intr_enable; 
>>>> +	temp_word = (temp_word & ~intr_enable) | intr_enable;
>>> *boggle*
>> Dig out your text editor, and notice the excess whitespace at the end of the line,
>> along with similar stuff on most other lines in this patch.
> 
> You, however, did clip the important line.
> 
>>> 	temp_word |= intr_enable;
> 
> which is what I was saying the above is equivalent to.

Gag-me.  That *is* bad.  But the PCIe folks seem to be extra sensitive
about the code, so I'm trying to change as little as possible here.
That line was just the result of doing this in vim:    :%s/[ 	]*$//g  

I agree there's a lot of funny looking code in there,
but that's not what this particular patch series is about.
You could submit a follow-up patch to repair that stuff, if you like.

Mmm.. I wonder how clever gcc is with a line like that.. ?  ;)

Cheers!
