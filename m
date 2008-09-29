Return-Path: <linux-kernel-owner+w=401wt.eu-S1752576AbYI2LMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbYI2LMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 07:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbYI2LM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 07:12:29 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:52096 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbYI2LM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 07:12:28 -0400
Message-ID: <CB0D828755EF47B78DA10F72C80BC436@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
To: "Ric Wheeler" <rwheeler@redhat.com>,
       "Christoph Hellwig" <hch@infradead.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Oleg Nesterov" <oleg@tv-sign.ru>, <linux-fsdevel@vger.kernel.org>,
       <dm-devel@redhat.com>, <viro@ZenIV.linux.org.uk>,
       <linux-ext4@vger.kernel.org>, <xfs@oss.sgi.com>, <axboe@kernel.dk>,
       <mtk.manpages@googlemail.com>, <linux-kernel@vger.kernel.org>
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org> <48DBFD42.6030307@redhat.com> <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp> <48DCC043.1020207@redhat.com>
In-Reply-To: <48DCC043.1020207@redhat.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Mon, 29 Sep 2008 20:11:41 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Windows Mail 6.0.6000.16480
X-MimeOLE: Produced By Microsoft MimeOLE V6.0.6000.16545
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ric and Christoph,

Ric Wheeler wrote:
>>>> And as with all previous posting I still fundamentally disagree about
>>>> the need of this functionality.  We don't need a timeout for freezing.
>>>
>>> I agree with Christoph here, I think that the timeout is unneeded.
>>
>> I think that your concern is that the freezer cannot recognize the occurrence
>> of a timeout and it continues the backup process and the backup data is
>> corrupted finally.
>> If the freezer can recognize it by the unfreeze ioctl's errono, will your concern
>> be solved?
>> If so, I will implement it.
>>
>> Cheers, Takashi
>>
> I think that is certainly part a big part of my concern.
>
> Also note that the timeout seems to be quite low relative to say the standard timeout for a SCSI 
> device (30 seconds worst case).
>
> In general, I am quite supportive of the patch series and think that this is a great addition.

Thank you for your comments.
Christoph, do you have any comments about this solution?

If it's OK, I will change the freeze patch so that the unfreeze ioctl sets
ETIMEDOUT to errno when the timeout occurs.

Cheers, Takashi
