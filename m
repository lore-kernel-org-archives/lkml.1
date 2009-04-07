Return-Path: <linux-kernel-owner+w=401wt.eu-S1752161AbZDGIcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbZDGIcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZDGIb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:31:59 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:10500 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbZDGIb6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 04:31:58 -0400
From: "Cai, Cliff" <Cliff.Cai@analog.com>
X-IronPort-AV: E=Sophos;i="4.39,336,1235970000"; 
   d="scan'208";a="85894743"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] mmc: align data size for host which only supports power-of-2 block
Date: Tue, 7 Apr 2009 16:34:37 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA03D4261F@chinexm1.ad.analog.com>
In-Reply-To: <20090405210900.644a81bb@mjolnir.ossman.eu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] mmc: align data size for host which only supports power-of-2 block
Thread-Index: Acm2If67xsUISJ4eSheg9aD6Kus+tABOEXlQ
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
CC: "Bryan Wu" <cooloney@kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 Apr 2009 08:31:28.0919 (UTC) FILETIME=[3F54AA70:01C9B75B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Pierre Ossman [mailto:drzeus-mmc@drzeus.cx] 
>Sent: Monday, April 06, 2009 3:09 AM
>To: Cai, Cliff
>Cc: Bryan Wu; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH] mmc: align data size for host which only 
>supports power-of-2 block
>
>On Thu, 26 Mar 2009 10:22:54 +0800
>"Cai, Cliff" <Cliff.Cai@analog.com> wrote:
>
>> >
>> >mmc_align_data_size() shouldn't be adjusting the size to 
>something it 
>> >can easily determine that it's invalid.
>> 
>> Should I create a new function to do the power-of-2 adjustment?
>> Or any ideal way to do it?
>
>That function is the correct place. My point was that we need 
>to check after the adjustment that we didn't violate any of 
>the other restrictions the driver has set. If we do, we should 
>just return the original value.

What are other restrictions?I don't see any other restrictions on data
size in current host driver
Except 4 byte alignment.


>> Otherwise,the SDH almost can't be used as sdio host.
>
>Unfortunately I think this controller will be very unsuitable 
>as an SDIO controller anyway with that restriction.

Yes,But since we need to support some SDIO devices according to our
customers'
Requests ,I think we have no other choice of this.


Thanks

Cliff
