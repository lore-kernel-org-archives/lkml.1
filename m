Return-Path: <linux-kernel-owner+w=401wt.eu-S1763086AbXJMSmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763086AbXJMSmL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 14:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762003AbXJMSly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 14:41:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39325 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761711AbXJMSlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 14:41:53 -0400
Message-ID: <4711116E.7070300@garzik.org>
Date: Sat, 13 Oct 2007 14:41:50 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Kuan Luo <kluo@nvidia.com>,
       Peer Chen <pchen@nvidia.com>
Subject: Re: 2.6.23-mm1
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>	 <20071012013729.ada2127b.akpm@linux-foundation.org>	 <64bb37e0710130101y7fb8e4c0lf214fd821e8305ed@mail.gmail.com>	 <4710A407.3070000@garzik.org>	 <64bb37e0710130503haa66d6eu93e75ecdc78ac866@mail.gmail.com>	 <4710B7C5.5050403@garzik.org>	 <64bb37e0710130732p303547e3n54cfa9dac34c53b5@mail.gmail.com>	 <64bb37e0710130740u78613f83wbd4f43d073bbe13d@mail.gmail.com>	 <64bb37e0710130813le68c48dve36f8473b197b84b@mail.gmail.com>	 <47110500.8050503@garzik.org> <64bb37e0710131105m7c64fca0kb71f3955170e8bec@mail.gmail.com>
In-Reply-To: <64bb37e0710131105m7c64fca0kb71f3955170e8bec@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten Kaiser wrote:
> On 10/13/07, Jeff Garzik <jeff@garzik.org> wrote:
>> Torsten Kaiser wrote:
>>> 3 boots, all worked. So I'm very sure that was the bug, but I will now
>>> do a little load testing...
>>>
>>> The only strange thing about 2.6.23-mm1 is, that it takes ~4 second
>>> more to boot.
>> So, you basically applied the attached patch?
>>
>> Yeah, absence of qc_defer for an NCQ-capable chip would do it.
> 
> Yes. The system seems to work correctly now.

Thanks for helping track this down.  Fix pushed out to libata-dev.git.

	Jeff



