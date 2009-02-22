Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbZBVJ1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbZBVJ1n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 04:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbZBVJ1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 04:27:32 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:17480 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750973AbZBVJ1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 04:27:31 -0500
Message-ID: <49A11A24.9080709@panasas.com>
Date: Sun, 22 Feb 2009 11:25:56 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.29-rc5
References: <1235170927.9025.42.camel@localhost.localdomain> <49A11860.3000406@panasas.com>
In-Reply-To: <49A11860.3000406@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Feb 2009 09:26:11.0773 (UTC) FILETIME=[99E36ED0:01C994CF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
Boaz Harrosh wrote:
> James Bottomley wrote:
>> This is a bunch of assorted bug fixes (with several in the qlogic
>> drivers).
>>
>> The patch is available at
>>
>> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
>>
>> The short changelog is:
>>
>> Andrew Vasquez (3):
>>       qla2xxx: Update version number to 8.03.00-k3.
>>       qla2xxx: Mask out 'reserved' bits while processing FLT regions.
>>       qla2xxx: Properly acknowledge IDC notification messages.
>>
>> Anirban Chakraborty (2):
>>       qla2xxx: Correct slab-error overwrite during vport creation and deletion.
>>       qla2xxx: Remove interrupt request bit check in the response processing pat
>>
>> Brian King (3):
>>       ibmvfc: Increase cancel timeout
>>       ibmvfc: Fix rport relogin
>>       ibmvfc: Fix command timeout errors
>>
>> James Smart (1):
>>       scsi_scan: add missing interim SDEV_DEL state if slave_alloc fails
>>
>> Julia Lawall (1):
>>       lpfc: introduce missing kfree
>>
>> Martin Peschke (1):
>>       sg: fix device number in blktrace data
>>
>> Mike Christie (1):
>>       libiscsi: Fix scsi command timeout oops in iscsi_eh_timed_out
>>
>> Robert Jennings (1):
>>       ibmvscsi: Correct DMA mapping leak
>>
>> Shyam_Iyer@Dell.com (1):
>>       qla2xxx: fix Kernel Panic with Qlogic 2472 Card.
>>
>>
>> And the diffstat
>>
> <snip>
> 
> James Hello.
> 
> Please, you must include a BUG fix patch I sent to the osd_uld, that was found
> by users, with use of old osd-targets. (It was sitting in next for a while now)
> It's an obvious BUG, no point of sending it the @stable way later.
> 
> http://www.spinics.net/lists/linux-scsi/msg33243.html
> 
> Do you need that I resend it?
> 
> Thanks in advance
> Boaz
> 

> James Bottomley wrote:
>> This is a bunch of assorted bug fixes (with several in the qlogic
>> drivers).
>>
>> The patch is available at
>>
>> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
>>
>> The short changelog is:
>>
>> Andrew Vasquez (3):
>>       qla2xxx: Update version number to 8.03.00-k3.
>>       qla2xxx: Mask out 'reserved' bits while processing FLT regions.
>>       qla2xxx: Properly acknowledge IDC notification messages.
>>
>> Anirban Chakraborty (2):
>>       qla2xxx: Correct slab-error overwrite during vport creation and deletion.
>>       qla2xxx: Remove interrupt request bit check in the response processing pat
>>
>> Brian King (3):
>>       ibmvfc: Increase cancel timeout
>>       ibmvfc: Fix rport relogin
>>       ibmvfc: Fix command timeout errors
>>
>> James Smart (1):
>>       scsi_scan: add missing interim SDEV_DEL state if slave_alloc fails
>>
>> Julia Lawall (1):
>>       lpfc: introduce missing kfree
>>
>> Martin Peschke (1):
>>       sg: fix device number in blktrace data
>>
>> Mike Christie (1):
>>       libiscsi: Fix scsi command timeout oops in iscsi_eh_timed_out
>>
>> Robert Jennings (1):
>>       ibmvscsi: Correct DMA mapping leak
>>
>> Shyam_Iyer@Dell.com (1):
>>       qla2xxx: fix Kernel Panic with Qlogic 2472 Card.
>>
>>
>> And the diffstat
>>
> <snip>
> 
> James Hello.
> 
> Please, you must include a BUG fix patch I sent to the osd_uld, that was found
> by users, with use of old osd-targets. (It was sitting in next for a while now)
> It's an obvious BUG, no point of sending it the @stable way later.
> 
> http://www.spinics.net/lists/linux-scsi/msg33243.html
> 
> Do you need that I resend it?
> 
> Thanks in advance
> Boaz
> 

Please, completely ignore. Need my morning coffee. Don't know what happened
to me, I did not smoke anything Friday night.

Sorry for the noise
Boaz


 
