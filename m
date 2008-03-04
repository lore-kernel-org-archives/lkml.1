Return-Path: <linux-kernel-owner+w=401wt.eu-S932259AbYCDQr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259AbYCDQr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756222AbYCDQrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:47:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47421 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757491AbYCDQrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:47:45 -0500
Date: Tue, 4 Mar 2008 17:47:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rick van Rein <rick@vanrein.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Message-ID: <20080304164732.GB16379@elte.hu>
References: <20080302134221.GA25196@phantom.vanrein.org> <20080303082238.GB13580@elte.hu> <47CC3005.5090706@zytor.com> <20080304133028.GC32383@elte.hu> <47CD78F0.2060802@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CD78F0.2060802@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

>>>>
>>> How is this different from:
>>>
>>> 	memmap=<size>$<len>
>>>
>>> ... ?
>>
>> it's the inverse? When we identify bad areas of RAM, we really want to 
>> "punch holes" into the existing memory map. So 'badram=' or 'excludemem=' 
>> would be nicer and easier to use.
>>
>> Or extend 'memmap=' with an inverse parameter: memmap=!0x10000000$1M would 
>> exclude a 1MB region at 256MB physical.
>>
>
> My understanding is that the $-form (as opposed to the @-form or 
> #-form) is exactly that:
>
>         memmap=nn[KMG]$ss[KMG]
>                         [KNL,ACPI] Mark specific memory as reserved.
>                         Region of memory to be used, from ss to ss+nn.
>
> "Reserved" usually means "don't use as either memory or free address 
> space".

ah - thanks - didnt know that!

i guess there might still be badram syntax details that might be worth 
merging, but "memmap=" looks a lot more complete than what i thought it 
to be.

	Ingo
