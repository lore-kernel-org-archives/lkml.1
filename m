Return-Path: <linux-kernel-owner+w=401wt.eu-S1756950AbZFCM4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbZFCM4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 08:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756412AbZFCMzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 08:55:50 -0400
Received: from smtp.nokia.com ([192.100.105.134]:47392 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883AbZFCMzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 08:55:49 -0400
Message-ID: <4A2672A8.8020809@nokia.com>
Date: Wed, 03 Jun 2009 15:55:04 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dmitry Pervushin <dpervushin@embeddedalley.com>
Subject: Re: linux-next: ubi tree build failure
References: <20090603184408.49c7fb1f.sfr@canb.auug.org.au> <4A265DF6.3070602@nokia.com>
In-Reply-To: <4A265DF6.3070602@nokia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Jun 2009 12:55:06.0066 (UTC) FILETIME=[84A18320:01C9E44A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> Stephen Rothwell wrote:
>> Today's linux-next build (powerpc ppc44x_defconfig) failed like this:
>>
>> drivers/mtd/ubi/gluebi.c: In function 'gluebi_get_device':
>> drivers/mtd/ubi/gluebi.c:126: error: implicit declaration of function 'IS_ERR'
>> drivers/mtd/ubi/gluebi.c:129: error: implicit declaration of function 'PTR_ERR'
> 
> It is strange that I do not see these errors on my x86_86
> 
>> Introduced by commit ec5c514efde253de7f28668c88bbae26d2a293de ("UBI: make
>> gluebi a separate module") from the ubi tree.  I guess the conversion
>> managed to remove an implicit include of linux/err.h.
>>
>> I have reverted that commit for today.  I then needed to also revert
>> commit 518ceef0c9ca97023e45ae46aedaefa240c690a6 ("UBI: remove built-in
>> gluebi") to make it build again.
> 
> Hmm, this means bisection problems, which I'd also like to fix.
> But this commit builds just fine for me as well. Would be nice
> to see what are the errors.
> 
> Any suggestions what I could do to reproduce the build issues?
> I'll try at least now to build this on x86 (32-bit). 

Did not see compile error on x86 as well. Anyway, I have added more
includes which seem to be missed. Hopefully this problem is fixed
now. Thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
