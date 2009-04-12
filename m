Return-Path: <linux-kernel-owner+w=401wt.eu-S1751920AbZDLQSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbZDLQSS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 12:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZDLQSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 12:18:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58380 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbZDLQSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 12:18:00 -0400
Message-ID: <49E213AE.4060506@redhat.com>
Date: Sun, 12 Apr 2009 19:15:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Szabolcs Szakacsits <szaka@ntfs-3g.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
References: <20090412091228.GA29937@elte.hu>	<Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net> <20090412162018.6c1507b4@lxorguk.ukuu.org.uk>
In-Reply-To: <20090412162018.6c1507b4@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> The atomic building units (sector size, block size, etc) of NTFS are 
>> entirely parametric. The maximum values could be bigger than the 
>> currently "configured" maximum limits. 
>>     
>
> That isn't what bites you - you can run 8K-32K ext2 file systems but if
> your physical page size is smaller than the fs page size you have a
> problem.
>
> The question is whether the NT VM can cope rather than the fs.
>   

A quick test shows that it can.  I didn't try mmap(), but copying files 
around worked.

Did you expect it not to work?

-- 
error compiling committee.c: too many arguments to function

