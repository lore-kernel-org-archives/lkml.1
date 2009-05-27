Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbZE0IYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbZE0IYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 04:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbZE0IY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 04:24:27 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:62317 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbZE0IYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 04:24:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=olypyN68xHzGcwP+hnEDvnlLiR8zDAigujfVsbTKeQrQI5UbACKyggbuS9Urke2yHB
         +OUM6wk2xzfN5q+IGU6q92eFcp0fgJ+VxCZAW1f+eco9UlhGD7EMF9Uy+cBWh2Y5iq9A
         PGgTdP/8JE16Om+F7Gn6R52QQ9UEXg8YYhORI=
MIME-Version: 1.0
In-Reply-To: <e9c3a7c20905261659v5d785df3w646efd4cbba2e6dd@mail.gmail.com>
References: <2a27d3730905220347s59dbd152kc69c8399693ae307@mail.gmail.com>
	 <e9c3a7c20905261659v5d785df3w646efd4cbba2e6dd@mail.gmail.com>
Date: Wed, 27 May 2009 16:24:26 +0800
X-Google-Sender-Auth: 3609251fe20483e6
Message-ID: <2a27d3730905270124q235cb2b9n1d079cf66a541028@mail.gmail.com>
Subject: Re: [GIT PULL] fsldma driver fixes
From: Li Yang <leoli@freescale.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linuxppc-dev Development <linuxppc-dev@ozlabs.org>,
       Ira Snyder <iws@ovro.caltech.edu>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 7:59 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Fri, May 22, 2009 at 3:47 AM, Li Yang <leoli@freescale.com> wrote:
>> Hi Dan,
>>
>> Here are fixes for Freescale DMA engine driver.
>>
>> Thanks,
>> - Leo
>>
>>
>> The following changes since commit 5805977e63a36ad56594a623f3bd2bebcb7db233:
>>  Linus Torvalds (1):
>>        Merge branch 'for-linus' of git://git.kernel.org/.../jbarnes/drm-2.6
>>
>> are available in the git repository at:
>>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/leo/fsl-soc.git fsldma
>>
>> Ira Snyder (4):
>>      fsldma: fix "DMA halt timeout!" errors
>>      fsldma: fix infinite loop on multi-descriptor DMA chain completion
>>      fsldma: snooping is not enabled for last entry in descriptor chain
>>      fsldma: fix memory leak on error path in fsl_dma_prep_memcpy()
>>
>> Li Yang (1):
>>      fsldma: update mailling list address in MAINTAINERS
>>
>> Roel Kluin (1):
>>      fsldma: fix check on potential fdev->chan[] overflow
>>
>
> Pulled, thanks.  These all look like 2.6.30 candidates, right?

Yes, they are pure fixes.

- Leo
