Return-Path: <linux-kernel-owner+w=401wt.eu-S1752993Ab0AGO74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab0AGO74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 09:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887Ab0AGO7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 09:59:55 -0500
Received: from exht1.emulex.com ([138.239.113.183]:1757 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752518Ab0AGO7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 09:59:55 -0500
Message-ID: <4B45F6D3.40903@emulex.com>
Date: Thu, 7 Jan 2010 09:59:31 -0500
From: James Smart <james.smart@emulex.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Thomas Backlund <tmb@mandriva.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Subject: Re: latest git pull changed drivers/scsi/lpfc/lpfc_hw4.h to executable
References: <4B45B496.90907@mandriva.org> <1262875521.3025.5.camel@mulgrave.site>
In-Reply-To: <1262875521.3025.5.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank You James. Sorry for the disruption.  This is what I get for moving to a 
git-derived patch, instead of my own diff scripts which ignore things like 
this. Don't know what changed it in the first place.

-- james s


James Bottomley wrote:
> On Thu, 2010-01-07 at 12:16 +0200, Thomas Backlund wrote:
>> At latest pull, lpfs_hw4.h got set to executable...
>>
>> git show def9c7a994f194377a23e687e6fd39b46c3ce631 --summary
>>
>> states:
>>
>> commit def9c7a994f194377a23e687e6fd39b46c3ce631
>> Author: James Smart <james.smart@emulex.com>
>> Date:   Mon Dec 21 17:02:28 2009 -0500
>>
>>      [SCSI] lpfc 8.3.7: Fix hardware/SLI relates issues
>>
>>      Fix hardware/SLI relates issues:
>>      - Fix CNA uses more than one EQ when in INTx interrupt mode.
>>      - Fix driver tries to process failed read FCF record mailbox request.
>>      - Fix allocating single receive buffer breaks FCoE receive queue.
>>      - Support new read FCF record mailbox error case.
>>
>>      Signed-off-by: James Smart <james.smart@emulex.com>
>>      Signed-off-by: James Bottomley <James.Bottomley@suse.de>
>>
>>   mode change 100644 => 100755 drivers/scsi/lpfc/lpfc_hw4.h
>>
>>
>> While looking at the same tree, I also noticed that:
>> drivers/scsi/lpfc/lpfc_hbadisc.c is also executable.
>>
>> I guess they should be fixed.
> 
> I'll remove the x flag for both.  I suppose a commit check that warns on
> executables might be in order, since adding them to the tree is a rare
> exception rather than a usual occurrence.
> 
> James
> 
> 
