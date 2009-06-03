Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbZFCIqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbZFCIqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbZFCIqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:46:07 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:40767 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbZFCIqF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:46:05 -0400
From: "Cai, Cliff" <Cliff.Cai@analog.com>
X-IronPort-AV: E=Sophos;i="4.41,297,1241409600"; 
   d="scan'208";a="88331224"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 04/11] Blackfin SPORT UART: fix overrun errors
Date: Wed, 3 Jun 2009 16:49:41 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA0422906C@chinexm1.ad.analog.com>
In-Reply-To: <8bd0f97a0906030103i64bc1a9duc5aeaea7bd3f8365@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 04/11] Blackfin SPORT UART: fix overrun errors
Thread-Index: AcnkIdTq/2eZfm3ZRFGtgpDbJsXiKAABi8Yw
References: <1243926700-30485-1-git-send-email-vapier@gentoo.org> <1243926700-30485-4-git-send-email-vapier@gentoo.org> <20090602100018.415b1dfc@lxorguk.ukuu.org.uk> <8bd0f97a0906030103i64bc1a9duc5aeaea7bd3f8365@mail.gmail.com>
To: "Mike Frysinger" <vapier.adi@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
CC: "Mike Frysinger" <vapier@gentoo.org>, <linux-serial@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>,
       <uclinux-dist-devel@blackfin.uclinux.org>,
       "Bryan Wu" <cooloney@kernel.org>
X-OriginalArrivalTime: 03 Jun 2009 08:46:06.0699 (UTC) FILETIME=[BC1303B0:01C9E427]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Mike Frysinger [mailto:vapier.adi@gmail.com] 
>Sent: Wednesday, June 03, 2009 4:04 PM
>To: Alan Cox
>Cc: Mike Frysinger; linux-serial@vger.kernel.org; 
>linux-kernel@vger.kernel.org; 
>uclinux-dist-devel@blackfin.uclinux.org; Cai, Cliff; Bryan Wu
>Subject: Re: [PATCH 04/11] Blackfin SPORT UART: fix overrun errors
>
>On Tue, Jun 2, 2009 at 05:00, Alan Cox wrote:
>> On Tue,  2 Jun 2009 03:11:33 -0400 Mike Frysinger wrote:
>>> From: Cliff Cai <cliff.cai@analog.com>
>>>
>>> Push the ty_flip_buffer_push() call from the IRQ handler to a timer 
>>> so as to improve performance and decrease likelihood of overruns.
>>
>> This should have no effect on a modern kernel.
>
>well, we wouldnt be making changes if we werent seeing data 
>overruns today
>
>> There is 64K of queueing between you and the ldisc nowdays.
>
>i dont think that really matters ... we do too much work in 
>the interrupt and so we miss new data
>
>> Furthermore unless you set tty->low_latency the kernel already 
>> basically does this aggregation for you as the buffer push queues 
>> stuff for the ldisc to wake up and process.
>
>i guess we could try setting the low_latency bool instead and 
>see if that fixes things -mike
>

The overrrun problem doesn't exist even without my patch now,so I will drop it.

Thanks

Cliff
