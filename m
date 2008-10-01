Return-Path: <linux-kernel-owner+w=401wt.eu-S1752935AbYJAK1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbYJAK1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 06:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbYJAK1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 06:27:32 -0400
Received: from ns.netcenter.hu ([195.228.254.57]:60181 "EHLO netcenter.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbYJAK1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 06:27:31 -0400
Message-ID: <409101c923af$c8092020$0400a8c0@dcccs>
From: "Janos Haar" <janos.haar@netcenter.hu>
To: "Milton Miller" <miltonm@bga.com>
Cc: <linux-kernel@vger.kernel.org>
References: <200809301450.m8UEo5wT027331@sullivan.realtime.net>
Subject: Re: How can i read really 512 byte?
Date: Wed, 1 Oct 2008 12:23:32 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-2";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----- 
From: "Milton Miller" <miltonm@bga.com>
To: "Janos Haar" <janos.haar@netcenter.hu>
Cc: <linux-kernel@vger.kernel.org>
Sent: Tuesday, September 30, 2008 4:50 PM
Subject: How can i read really 512 byte?


> On Tue, 30 Sep 2008 at 08:29:15 -0400 (EDT), Janos Haar wrote:
>> Now i am working on recover some data from one defective drive.  I
>> am using dd_rescue, and dd, but both ready only 4K, i think, because
>> the kernel's block size is 4K.
>> 
>> I have tried to google for the solution, but only found this trick:
>> 
>> losetup /dev/loop0 /dev/hdc
>> blockdev --setbsz 512 /dev/hdc
>> 
>> and after this set, trying to read the hdc...
>> 
>> It looks like working on the first look, but not really. :-( The
>> 512 size bad sectors still have 4K sizes, but the reading attempt
>> takes more (8x ?) longer.
>> 
>> Somebody can help me to set the reading block size to 512 byte?
> 
> You need to add O_DIRECT to the open call in the flags parameter
> (the second argument).   (My brother tested this a year or so ago,
> and it worked for him).
> 
> milton

Hello,

Thank you for the information.
Can you help me a little bit more?
Where need to add this parameter?
In the kernel, in the blocked's source, or in the dd_rescue's source?

Thanks,
Janos Haar
