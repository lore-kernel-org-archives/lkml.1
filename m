Return-Path: <linux-kernel-owner+w=401wt.eu-S1760943AbYCDRQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943AbYCDRQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756760AbYCDRQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:16:28 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:13088 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272AbYCDRQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:16:28 -0500
Message-ID: <47CD8391.2040101@oracle.com>
Date: Tue, 04 Mar 2008 09:14:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ISS StorageDev <iss_storagedev@hp.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.25-rc3-mm1 (CCISS)
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <20080304084557.357972a3.randy.dunlap@oracle.com> <DEE40752C8AF224BB890E455C7B8E0FE042B764935@G6W0268.americas.hpqcorp.net>
In-Reply-To: <DEE40752C8AF224BB890E455C7B8E0FE042B764935@G6W0268.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miller, Mike (OS Dev) wrote:
> Randy wrote:
>> On Tue, 4 Mar 2008 01:19:28 -0800 Andrew Morton wrote:
>>
>>>
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-r
>>> c3/2.6.25-rc3-mm1/
>> With
>> CONFIG_BLK_CPQ_DA=m
>> CONFIG_BLK_CPQ_CISS_DA=m
>> # CONFIG_CISS_SCSI_TAPE is not set
>>
>> I'm getting
>> In file included from drivers/block/cciss.c:230:
>> drivers/block/cciss_scsi.c:1498:38: error: macro parameters
>> must be comma-separated
>> drivers/block/cciss.c: In function 'cciss_seq_show_header':
>> drivers/block/cciss.c:271: error: implicit declaration of
>> function 'cciss_seq_tape_report'
>> drivers/block/cciss.c: In function 'cciss_proc_write':
>> drivers/block/cciss.c:392: error: implicit declaration of
>> function 'cciss_engage_scsi'
>> make[2]: *** [drivers/block/cciss.o] Error 1
>> make[1]: *** [drivers/block] Error 2
>> make[1]: *** Waiting for unfinished jobs....
>>
>> ---
> Randy,
> It looks like you have the original broken patch. I resubmitted and I think Jens picked up the fixed patch but I don't know where it is...  :(

s/you/latest -mm/

I thought that this had been fixed, but I can't find it either... :(

Jens, did you queue a patch for this?

-- 
~Randy
