Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbZALESV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbZALESV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 23:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZALESM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 23:18:12 -0500
Received: from smtp-out.google.com ([216.239.45.13]:16168 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbZALESL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 23:18:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=yiXVJ3ob6FfrGi/wrxTDLz1MYvOP2tZYejX6HHSkUt83COCTOfP4IwJ8khJVX+1Zx
	arccGssIlsmPDyaEqMSJA==
MIME-Version: 1.0
In-Reply-To: <3838.1231647500@turing-police.cc.vt.edu>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	 <20090105175433.D875.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20090105010726.c0433fea.akpm@linux-foundation.org>
	 <6991.1231194895@turing-police.cc.vt.edu>
	 <604427e00901072018o42ff0627yb5282f2a81a13c65@mail.gmail.com>
	 <3838.1231647500@turing-police.cc.vt.edu>
Date: Sun, 11 Jan 2009 20:18:06 -0800
Message-ID: <604427e00901112018p43e96f1fw555dceccaa419147@mail.gmail.com>
Subject: Re: 2.6.29 -mm merge plans
From: Ying Han <yinghan@google.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Mike Waychison <mikew@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.93
X-GMailtapped: yinghan
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you Valdis for your work and that is a really good news. :-)

--Ying

On Sat, Jan 10, 2009 at 8:18 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Wed, 07 Jan 2009 20:18:34 PST, Ying Han said:
>> Hi Valdis:
>>      Please try this fix and i tested on ubunbu8.10 with xmms and it helps.
>
> Sorry for the long delay in testing, I was offline Wed-Friday taking some
> much-needed leave time.
>
>> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
>> index 9e268b6..f4bbd9b 100644
>> --- a/arch/x86/mm/fault.c
>> +++ b/arch/x86/mm/fault.c
>
> This didn't apply cleanly to a mmotm-0105 tree, but did apply cleanly
> with the following 3 patches reverted and then this new patch applied.
>
>        page_fault-retry-with-nopage_retry.patch
>        page_fault-retry-with-nopage_retry-fix.patch
>        page_fault-retry-with-nopage_retry-fix-fix.patch
>
> not surprising, since it looks like this patch is a replacement for all 3.  It
> built and booted nicely, and xmms on the resulting kernel behaves properly.
>
> Congrats on being able to debug the problem based on my fairly weird bug
> report. ;)
>
