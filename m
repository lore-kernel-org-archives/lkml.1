Return-Path: <linux-kernel-owner+w=401wt.eu-S1764063AbXGPMKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764063AbXGPMKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 08:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756183AbXGPMJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 08:09:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:53949 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804AbXGPMJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 08:09:56 -0400
In-Reply-To: <1184368328.6059.271.camel@localhost.localdomain>
References: <20070704132212.726923000@pademelon.sonytel.be> <Pine.LNX.4.62.0707131541150.18802@pademelon.sonytel.be> <1184335333.3402.20.camel@localhost.localdomain> <200707131619.54898.arnd@arndb.de> <1184368328.6059.271.camel@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <0A74AFF2-CBDA-4B00-AF5F-B6C6DACE0E16@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
       James Bottomley <James.Bottomley@steeleye.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
Date: Mon, 16 Jul 2007 14:08:57 +0200
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> I'm pretty sure that no ppc64 machine needs alias resolution in  
>> the kernel,
>> although some are VIPT. Last time we discussed this, Segher  
>> explained it
>> to me, but I don't remember which way Cell does it. IIRC, it  
>> automatically
>> flushes cache lines that are accessed through aliases.
>
> Ah yes, I remember reading about this automatic flushing thing. I  
> don't
> know how the caches actually work on most of our PPC's, but the  
> fact is,
> we don't have aliasing issues, so I can safely ignore it for a bit
> longer :-)

That is the very short version of the story, yes: some
PowerPC implementations are VIPT physically, but there
are no aliasing issues we have to worry about.

Anyone interested in how this works, can download the
PPC970 UM (or 970FX or 970MP); it has a very detailed
explanation of all this.  Cell might be slightly different
but the base idea is the same.


Segher

