Return-Path: <linux-kernel-owner+w=401wt.eu-S1751744AbZDNKLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbZDNKLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbZDNKLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:11:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36673 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbZDNKLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:11:30 -0400
Message-ID: <49E46057.6000506@redhat.com>
Date: Tue, 14 Apr 2009 13:07:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Szabolcs Szakacsits <szaka@ntfs-3g.com>,
       Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
References: <20090412091228.GA29937@elte.hu>	<Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net>	<20090412162018.6c1507b4@lxorguk.ukuu.org.uk>	<49E213AE.4060506@redhat.com>	<alpine.LFD.2.00.0904120950050.4583@localhost.localdomain>	<49E2DC96.6090407@redhat.com>	<alpine.LFD.2.00.0904130747440.4583@localhost.localdomain> <874owr8ztm.fsf@basil.nowhere.org>
In-Reply-To: <874owr8ztm.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
>   
>> You absolutely do _not_ want to manage memory in 16kB chunks (or 64kB for 
>> your example!).
>>     
>
> AFAIK at least for user visible anonymous memory Windows uses 64k 
> chunks. At least that is what Cygwin's mmap exposes. I don't know
> if it does the same for disk cache.
>   

I think that's just the region address and size granularity (as in 
vmas).  For paging they still use the mmu page size.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

