Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbYGGN04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbYGGN04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 09:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbYGGN0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 09:26:49 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:40389 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbYGGN0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 09:26:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mQI57BX7hR0QlDvR/cYJPbRaWo84zCyFAHkzq+KrVZzAJQvyjnPO1H0PExX6aHaw+5
         kfKvuf8Z34TblzcknIBAXoNmtpu2DoPef/2cccw1SvxMxBvvVH5/wjW3Y6l3YDesMzVH
         Ky7T/HHGZZX17x78qTv30+iSdfEuxO9YZ9PWo=
Message-ID: <961aa3350807070626m37b3e218sb29303987e6983a2@mail.gmail.com>
Date: Mon, 7 Jul 2008 22:26:47 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2/2] swsusp: simplify memory bitmap
Cc: linux-kernel@vger.kernel.org, "Pavel Machek" <pavel@suse.cz>,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <200807071449.11817.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080705110946.GA17071@localhost.localdomain>
	 <20080705111123.GB17071@localhost.localdomain>
	 <200807071449.11817.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/7 Rafael J. Wysocki <rjw@sisk.pl>:
> On Saturday, 5 of July 2008, Akinobu Mita wrote:
>> This patch simplifies the memory bitmap manipulations.
>>
>> - remove the member size in struct bm_block
>>
>> It is not necessary for struct bm_block to have the number of bit chunks
>> that can be calculated by using end_pfn and start_pfn.
>>
>> - use find_next_bit() for memory_bm_next_pfn
>>
>> No need to invent the bitmap library only for the memory bitmap.
>
> Thanks for doing this change, it looks OK.
>
> I haven't have the time to test it yet, but once it's been tested, I'll push
> it to Andrew for merging.  I'll fold patch 1/2 into this one.

Thanks. I have only tested it on an x86_64 box.
