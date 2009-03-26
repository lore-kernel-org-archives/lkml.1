Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbZCZCT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbZCZCT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 22:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZCZCTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 22:19:46 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:65064 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbZCZCTq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 22:19:46 -0400
From: "Cai, Cliff" <Cliff.Cai@analog.com>
X-IronPort-AV: E=Sophos;i="4.38,422,1233550800"; 
   d="scan'208";a="68526061"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] mmc: align data size for host which only supports power-of-2 block
Date: Thu, 26 Mar 2009 10:22:54 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA03C5E04A@chinexm1.ad.analog.com>
In-Reply-To: <20090325202335.42abc221@mjolnir.ossman.eu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] mmc: align data size for host which only supports power-of-2 block
Thread-Index: AcmtfzfgotKrBzh8Tr2n1vUhywDMJAAOgGOA
References: <1236309321-23955-1-git-send-email-cooloney@kernel.org><20090314213038.4d14526e@mjolnir.ossman.eu><0F1B54C89D5F954D8535DB252AF412FA03C5D7C5@chinexm1.ad.analog.com> <20090325202335.42abc221@mjolnir.ossman.eu>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
CC: "Bryan Wu" <cooloney@kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 26 Mar 2009 02:19:43.0530 (UTC) FILETIME=[535368A0:01C9ADB9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>
 

>-----Original Message-----
>From: Pierre Ossman [mailto:drzeus-mmc@drzeus.cx] 
>Sent: Thursday, March 26, 2009 3:24 AM
>To: Cai, Cliff
>Cc: Bryan Wu; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH] mmc: align data size for host which only 
>supports power-of-2 block
>
>On Wed, 25 Mar 2009 11:22:25 +0800
>"Cai, Cliff" <Cliff.Cai@analog.com> wrote:
>
>> >
>> >This patch seems premature as there is no associated 
>modification of 
>> >any of the host drivers.
>> 
>> The SDH on Blackfin BF54x/BF51x only supports power-of-2 block 
>> transfer,we will soon Send the sdh driver to mainline as well.
>> 
>
>Ok. Looking forward to it. :)
>
>> >Padding to a power of two size can also mean a rather large 
>> >padding. We might need to check the host data limits after 
>> >doing the adjustment.
>> 
>> Yes,but it's the higher level driver's job. 
>> 
>
>mmc_align_data_size() shouldn't be adjusting the size to something it
>can easily determine that it's invalid.

Should I create a new function to do the power-of-2 adjustment?
Or any ideal way to do it?
Otherwise,the SDH almost can't be used as sdio host.

Thanks 

Cliff
