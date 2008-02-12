Return-Path: <linux-kernel-owner+w=401wt.eu-S1759168AbYBLJna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168AbYBLJna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 04:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758572AbYBLJnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 04:43:22 -0500
Received: from smtp.nokia.com ([192.100.122.233]:45430 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088AbYBLJnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 04:43:21 -0500
Message-ID: <47B167EA.1070402@yandex.ru>
Date: Tue, 12 Feb 2008 11:33:30 +0200
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: caglar@pardus.org.tr
CC: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] Silent compiler warning introduced by commit 801c135ce73d5df1caf3eca35b66a10824ae0707
 (UBI: Unsorted Block Images)
References: <200802100537.47634.caglar@pardus.org.tr> <47AEB829.8060104@gmail.com> <200802110144.07549.caglar@pardus.org.tr>
In-Reply-To: <200802110144.07549.caglar@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 12 Feb 2008 09:36:09.0217 (UTC) FILETIME=[B2AC2710:01C86D5A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S.Çağlar Onur wrote:
> Hi;
> 
> 10 Şub 2008 Paz tarihinde, Jiri Slaby şunları yazmıştı: 
>> I think this is not correct. You change the err which caused the failure. You 
>> change it even to 0 if it doesn't fail and the whole function will seem like 
>> non-failing.
> 
> My bad, sorry for not looking carefully. Assuming a refactoring is not desired for just a compiler warning, is following acceptable (this kind of plain messages seems heavily used in vmt.c, so i'm again assuming its OK to use such style)?
> 
> commit 801c135ce73d5df1caf3eca35b66a10824ae0707 (UBI: Unsorted Block Images) introduced the warning
> 
> drivers/mtd/ubi/vmt.c: In function `ubi_create_volume':
> drivers/mtd/ubi/vmt.c:379: warning: statement with no effect
> 
> 
>  drivers/mtd/ubi/vmt.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 

Thanks, applied to UBI git with Minor changes, will send git-pull request
shortly.

Please, note that my e-mail address is not dedekind@linutronix.de,
see MAINTAINERS.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
