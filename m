Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbZADI7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbZADI7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 03:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbZADI7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 03:59:09 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:11280 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750858AbZADI7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 03:59:08 -0500
Message-ID: <49607A56.2000001@panasas.com>
Date: Sun, 04 Jan 2009 10:59:02 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: avishay@gmail.com, jeff@garzik.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org,
       linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 7/9] exofs: mkexofs
References: <4947BFAA.4030208@panasas.com>	<4947CA5C.50104@panasas.com>	 <20081229121423.efde9d06.akpm@linux-foundation.org>	 <495B8D90.1090004@panasas.com>	 <20081231112515.2d790d1c.akpm@linux-foundation.org>	 <495CC612.30800@panasas.com> <1230936386.3304.22.camel@localhost.localdomain>
In-Reply-To: <1230936386.3304.22.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jan 2009 08:59:01.0246 (UTC) FILETIME=[AFC701E0:01C96E4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Thu, 2009-01-01 at 15:33 +0200, Boaz Harrosh wrote:
>> Andrew Morton wrote:
>>>>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>>> When, if, all is fixed, through which tree/maintainer can exofs be submitted?
>>> I can merge them.  Or you can run a git tree of your own, add it to
>>> linux-next and ask Linus to pull it at the appropriate time.
>>>
>> Hi James
>>
>> Andrew suggested that maybe I should push exofs file system directly to
>> Linus as it is pretty orthogonal to any other work. Sitting in linux-next
>> will quickly expose any advancements in VFS and will force me to keep
>> the tree uptodate.
>>
>> If that is so, and is accepted by Linus, would you rather that also the
>> open-osd initiator library will be submitted through the same tree?
>> The conflicts with scsi are very very narrow. The only real dependency
>> is the ULD being a SCSI ULD. I will routinely ask your ACK on any scsi 
>> or ULD related patches. Which are very few. This way it will be easier
>> to manage the dependencies between the OSD work, the OSD pNFS-Objects
>> trees at pNFS project, and the pNFSD+EXOFS export. One less dependency.
>>
>> [I already have such a public tree at git.open-osd.org for a while now]
> 
> Since it's sitting in SCSI, at least the libosd piece belongs over the
> SCSI mailing list, so I think it makes sense to continue updating it via
> the SCSI tree.
> 
> What's the status of the major number request from LANANA.  That's patch
> number one, and I haven't heard that they've confirmed the selection of
> 260 yet; or is LANANA now dead and it's who gets the major into the tree
> first?
> 
> James
> 

LANANA seems dead. I was unable to get any response from any e-mail.
Andrew?

Thanks James. I will personally prefer if these patches will carry
your sign-off on them, thous gaining your long acquired instincts.
That could be really grate.

I will send a new batch tomorrow morning, as Andrew had concerns with
some members names. Unless you prefer a git tree, drop me a note and
I'll send you a URL instead.

Thanks
Boaz
