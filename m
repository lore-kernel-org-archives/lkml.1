Return-Path: <linux-kernel-owner+w=401wt.eu-S1760965AbXHIXfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbXHIXfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 19:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbXHIXey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 19:34:54 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:4241 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbXHIXex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 19:34:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=iJ4cRFLyElIugZk18lAT3Vk2ZanlUdYbFJgWLOqWgETNTgRxXVfThSZ8I0DF6QPAXKkIAjLmC0r8D55sWIWRuox+jwiJW6X4O0k91Je+zfGTDc5DCske6cfw6k5X+eadNFAmbw7tQGvu+pZXnRjAa3CONAXrrRtQ5kz3QmvEeJ0=
Message-ID: <46BBA42C.5050307@googlemail.com>
Date: Fri, 10 Aug 2007 01:33:00 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Beulich <jbeulich@novell.com>,
       "Kristofer T. Karas" <ktk@enterprise.bidmc.harvard.edu>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg KH <greg@kroah.com>
Subject: Re: 2.6.23-rc2-mm1
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org>	<46BB88C4.5010107@googlemail.com>	<20070809150454.42eea7c5.akpm@linux-foundation.org> <20070809234215.212ac954@the-village.bc.nu>
In-Reply-To: <20070809234215.212ac954@the-village.bc.nu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> [   28.828484] 0000:00:1f.1: cannot adjust BAR0 (not I/O)
>>> [   28.828487] 0000:00:1f.1: cannot adjust BAR1 (not I/O)
>>> [   28.828489] 0000:00:1f.1: cannot adjust BAR2 (not I/O)
>>> [   28.828491] 0000:00:1f.1: cannot adjust BAR3 (not I/O)
> 
> This means it didn't do anything. (wrongly because its checking I/O bits
> on a BAR which are ignored according to the spec)
> 
>>>         Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
>>>         Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
>>>         Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
>>>         Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
> 
> The controller is disabled and when disabled it seems to think its
> memory. Valid but interesting.
> 
> 

The box is an Dell Precision WorkStation 530 MT.

Actually I have an ATA-7 disc on the primary EIDE connector ( one port free ) and an oldish CDROM
on the secondary EIDE connector ( one port free ).

http://194.231.229.228/lara/lara.dmesg ( from 2.6.23-rc2-mm1 with the 2 patches reverted )
http://194.231.229.228/lara/lara.lspci ( lspci -vvvvxxxx -nn )
http://194.231.229.228/lara/lara.html ( lshw html output )

If you want me to do/try something let me know.


Gabriel
