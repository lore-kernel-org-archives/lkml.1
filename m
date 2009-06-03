Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbZFCXdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbZFCXdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 19:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbZFCXdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 19:33:24 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:6978 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZFCXdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 19:33:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AZFMbzkf/RkVvE96UpyFdLcWi37rQhbU326SYWz9vUq7R6bHpZOY9TeM3saGk7Ikyw
         AiQH9K1sgorcc0Ra9eWHJBsCT2tiuyWiq37LUL0NsoyqWRnx+oedIA1phx7dwHxbtnOt
         CbnYCg2l2NLBLDG+vxkL0jyD0aOO7dTtxchyk=
Message-ID: <4A270841.7070107@gmail.com>
Date: Wed, 03 Jun 2009 17:33:21 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Kasper Sandberg <lkml@metanurb.dk>
CC: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: sata_sil24 0000:04:00.0: DMA-API: device driver frees DMA sg
 list  with different entry count [map count=13] [unmap count=10]
References: <64bb37e0905261214g2957924ar837339367f320d4c@mail.gmail.com>	 <4A1C7DDB.9010605@gmail.com>	 <64bb37e0906031230m22234268k9fdcd43dc1d35f18@mail.gmail.com> <1244060503.11698.3.camel@localhost>
In-Reply-To: <1244060503.11698.3.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kasper Sandberg wrote:
> On Wed, 2009-06-03 at 21:30 +0200, Torsten Kaiser wrote:
>> On Wed, May 27, 2009 at 1:40 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
>>> Torsten Kaiser wrote:
>>>> On upgrading to 2.6.30-rc1 I enable the DMA-Debugging option
>>>> CONFIG_DMA_API_DEBUG=y
>>>> Since then I get the following or similar errors on each boot:
>>> Please retest with a newer -rc, this patch likely fixes it:
>>>
>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5825627c9463581fd9e70f8285685889ae5bb9bb
>>>
>> Still happens with 2.6.30-rc8 (see trace at the end of the email)
>>
> <snip>
> 
> Does this actually give you any problems? should I be scared to give .30
> a test?

If Torsten's diagnosis is correct it's a problem with the DMA debugging 
code, not an actual driver bug.
