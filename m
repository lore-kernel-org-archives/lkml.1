Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbZKCWYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbZKCWYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 17:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbZKCWYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 17:24:12 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:39126 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbZKCWYM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 17:24:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cn6K76kqzrftEtPVLWsQPGUPUofD3qxRLX16t1Uq2MpVWFQi1J/pc5IR/0hu/qiZwI
         U0ZCLDLe0Fqfm7RiulMJf8S7LTzDWH+YcvTIha+/UqUFFLrvi3syvdYiu1x2cGrdLYax
         prqKL2tMYm3Ocl58/vwqYGyNKpzo4E88cyouI=
MIME-Version: 1.0
In-Reply-To: <20091103221541.GA25401@linux-mips.org>
References: <200911030701.nA371cAP019835@imap1.linux-foundation.org>
	 <20091103140953.GA23611@linux-mips.org>
	 <20091103085613.373634ab.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0911032243530.6542@localhost.localdomain>
	 <20091103221541.GA25401@linux-mips.org>
Date: Tue, 3 Nov 2009 23:24:15 +0100
X-Google-Sender-Auth: 1297feb2ae056ea3
Message-ID: <520f0cf10911031424j370d1344ia46f6c903adbaf77@mail.gmail.com>
Subject: Re: [PATCH cleanup] Re: + mips-vpe-remove-leftover-unlock_kernel.patch 
	added to -mm tree
From: John Kacur <jkacur@redhat.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 3, 2009 at 11:15 PM, Ralf Baechle <ralf@linux-mips.org> wrote:
> On Tue, Nov 03, 2009 at 10:52:41PM +0100, John Kacur wrote:
>
>> > > I already have an equivalent patch in the MIPS kernel - Linus only needs
>> > > to finally pull ...
>> > >
>> >
>> > I didn't see such a patch in yesterday's linux-next..
>
> I only have stuff to be pulled for 2.6.33 on my -next tree.  Anything for
> 2.6.32 was in another tree.
>
>> Linus picked-up Ralf's version of the patch for 2.6.32-rc6
>> a22d621c80fb08f668ae3bfe62aeaae64b0b2b89
>>
>> That has the important part that removes the stray unlock_kernel, but
>> unfortunately doesn't remove the smp_lock.h header.
>>
>> So, the last patch is just a clean-up. (no urgency).
>>
>> >From ae20d9169893112daaad1dc3af9f8559003a2bfb Mon Sep 17 00:00:00 2001
>> From: John Kacur <jkacur@redhat.com>
>> Date: Tue, 3 Nov 2009 22:15:55 +0100
>> Subject: [PATCH] Remove BKL header.
>>
>> Now that the bkl has been removed, also remove the smp_lock.h include
>
> In fact every single use of <linux/smp_lock.h> in arch/mips/ is unnecessary;
> see patch for 2.6.33 in
>
> http://www.linux-mips.org/git?p=upstream-sfr.git;a=commit;h=defde8dd822ddbab4ea1f8d2f5831e693bc75ad4
>
>  Ralf

Ah, great! Thanks Ralf.
