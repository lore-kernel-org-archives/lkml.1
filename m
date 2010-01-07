Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698Ab0AGG1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab0AGG1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 01:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949Ab0AGG1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 01:27:32 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:46722 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab0AGG1c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 01:27:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=fFkO7fgfiirnBpVhicE738P1EKkgmG4KFnsct/1FbuOD2roUsOgBgEzvapwshTVBT9
         7EP/f1ilJ3himJlxBUzpKEGMLM6ggJQPiNyCxyOIoNXvUzgDFAkJGqMJoqwQWsy6WCPq
         PzngcISnq8jqapOCPOTF4sj7Ll/U9xp04ec/Q=
MIME-Version: 1.0
In-Reply-To: <4B451164.3010100@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-10-git-send-email-jason.wessel@windriver.com> 
	<8bd0f97a0912261312x4b7c7df6s14ac0137b702044e@mail.gmail.com> 
	<0F1B54C89D5F954D8535DB252AF412FA0553E3A0@chinexm1.ad.analog.com> 
	<4e5ebad50912301845p35b1ea98l2f91c2a209ee863a@mail.gmail.com> 
	<4B44E7E3.10305@windriver.com> <8bd0f97a1001061208x8876e79y507d98e505071067@mail.gmail.com> 
	<4B44F3EA.7090002@windriver.com> <8bd0f97a1001061239x5e815590ue7044a4df00df13a@mail.gmail.com> 
	<4B451164.3010100@windriver.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 7 Jan 2010 01:27:11 -0500
Message-ID: <8bd0f97a1001062227g26e0abcl5fbee561ac7d3739@mail.gmail.com>
Subject: Re: [Kgdb-bugreport] [PATCH 09/37] kgdb,blackfin: Add in 
	kgdb_arch_set_pc for blackfin
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Sonic Zhang <sonic.adi@gmail.com>, "Zhang, Sonic" <Sonic.Zhang@analog.com>,
       kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 6, 2010 at 17:40, Jason Wessel wrote:
> Mike Frysinger wrote:
>> On Wed, Jan 6, 2010 at 15:34, Jason Wessel wrote:
>>> Mike Frysinger wrote:
>>>> also, i see you added "notrace" to the Blackfin probe_kernel_write ...
>>>> was that intentional ?  if so, this should probably go into
>>>> include/linux/uaccess.h instead
>>>>
>>> The notrace was just a cut and paste of the original in mm/maccess.c
>>
>> ah, i thought i checked mm/maccess.c, but i guess i looked at just
>> probe_kernel_read().  the fact that this was missed under the Blackfin
>> code is a good example for why notrace should be on prototypes, not
>> function definitions :).  i'll send a sep patch for just this.
>
> Thanks for the input.  I made the changes you talked about and tested
> the compilation on all the kgdb regression compiles.
>
> I split the patch into 2 parts, 1 for the generic change, and 1 for the
> blackfin cleanup.  Let me know if you approve and I can add acks from
> you as well.

i'd drop the notrace from the Blackfin probe_kernel_write and the
common __probe_kernel_write ... but otherwise, looks good.  thanks
again.
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
-mike
