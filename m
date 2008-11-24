Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbYKXGkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbYKXGkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 01:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbYKXGkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 01:40:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:29536 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYKXGkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 01:40:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SHI601e6N7OGAm0xdsC5tMSs2/ufTlKCkFkZnWlMgvWqWZW1uusC7bkYEtXk30qil/
         X5xr7Zdn/kMvy5YBJ/24O65pU09sKRP45om8UEVXHQLf+0itHalCDtwAv1Bq3nmlM11h
         oUVBel+wpGw2VBGNBznoDvwPDsWBjLx2FBhYM=
Message-ID: <df9815e70811232240y7480edao14d653c24cf2e01@mail.gmail.com>
Date: Mon, 24 Nov 2008 14:40:06 +0800
From: "Jike Song" <albcamus@gmail.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: system fails to boot
Cc: "Jens Axboe" <jens.axboe@oracle.com>, tj@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, pjones@redhat.com,
       alex.shi@intel.com
In-Reply-To: <1227505921.2866.148.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226639781.2866.77.camel@ymzhang>
	 <df9815e70811210926x28bfc368xb54298dd6b7ddd83@mail.gmail.com>
	 <1227505921.2866.148.camel@ymzhang>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 1:52 PM, Zhang, Yanmin
<yanmin_zhang@linux.intel.com> wrote:
>
> On Sat, 2008-11-22 at 01:26 +0800, Jike Song wrote:
>> On Fri, Nov 14, 2008 at 1:16 PM, Zhang, Yanmin
>> <yanmin_zhang@linux.intel.com> wrote:
>> > Jens,
>> >
>> > We run into system boot failure with kernel 2.6.28-rc. We found it on a couple of
>> > machines, including T61 notebook, nehalem machine, and another HPC NX6325 notebook.
>> > All the machines use FedoraCore 8 or FedoraCore 9. With kernel prior to 2.6.28-rc,
>> > system boot doesn't fail.
>> >
>> > I debug it and locate the root cause. Pls. see
>> > http://bugzilla.kernel.org/show_bug.cgi?id=11899
>> > https://bugzilla.redhat.com/show_bug.cgi?id=471517
>> >
>>
>> Hi Yanmin,
>>
>> It seems I still have this problem with -rc6, both root=LABEL and
>> root=/dev/sda8.  I have replaced my nash/mkinitrd with patched ones.
> Did you recreate the initrd after updating nash/mkinitrd tools?

Yes, I run "make install" at first, and found the failure of boot;
Then I recreated initrd manually with mkinitrd/nash (patched by you),
and booted -rc6 again - failed again.

> What's the boot log?
Sorry I don't have the laptop with me now, will post it this
evening(Ah, only possible if I can get netconsole work).   Anyway,
your patches did work for me with -rc4, so I think I'll bisect it.

-- 
Thanks,
Jike
