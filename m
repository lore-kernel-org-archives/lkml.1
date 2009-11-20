Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbZKTTP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbZKTTP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 14:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbZKTTP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 14:15:26 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:41332 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbZKTTPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 14:15:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dxBtuOoKFtO5ZLjgE5SKH28u9Ya86BdJferKIet1ksuiBwQN8Z3AyapyaEi4egfsPX
         L0TvO8ZZJgNj7Y4+G8a1vqvd+FDajCmN4oHr5CkkxnkJ1FClObQAyOr4giLwGAs7YiOw
         Zf4lw7osg9S480vqFNvggTGatwdo9Vd43UEOE=
MIME-Version: 1.0
In-Reply-To: <4B0215E3.2020400@pobox.com>
References: <1257708657-1232-1-git-send-email-tfransosi@gmail.com>
	 <4B0215E3.2020400@pobox.com>
Date: Fri, 20 Nov 2009 17:15:29 -0200
Message-ID: <a4c8a6d00911201115s276bb2a7i2a2c546356b71842@mail.gmail.com>
Subject: Re: [PATCH] ata: Clean up hard coded array size calculation.
From: Thiago Farina <tfransosi@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: mlord@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

On Tue, Nov 17, 2009 at 1:17 AM, Jeff Garzik <jgarzik@pobox.com> wrote:
> On 11/08/2009 02:30 PM, Thiago Farina wrote:
>>
>> Use ARRAY_SIZE macro of kernel api instead.
>>
>> Signed-off-by: Thiago Farina<tfransosi@gmail.com>
>> ---
>>  drivers/ata/sata_mv.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
>> index 6f5093b..a8a7be0 100644
>> --- a/drivers/ata/sata_mv.c
>> +++ b/drivers/ata/sata_mv.c
>> @@ -2217,7 +2217,7 @@ static unsigned int mv_qc_issue_fis(struct
>> ata_queued_cmd *qc)
>>        int err = 0;
>>
>>        ata_tf_to_fis(&qc->tf, link->pmp, 1, (void *)fis);
>> -       err = mv_send_fis(ap, fis, sizeof(fis) / sizeof(fis[0]));
>> +       err = mv_send_fis(ap, fis, ARRAY_SIZE(fis));
>>        if (err)
>
> applied

Was it applied to this tree
http://git.kernel.org/?p=linux/kernel/git/jgarzik/libata-dev.git?
