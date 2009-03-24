Return-Path: <linux-kernel-owner+w=401wt.eu-S1760291AbZCXNa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291AbZCXNa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbZCXNaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:30:20 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:57862 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701AbZCXNaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:30:19 -0400
Message-ID: <49C8E1C4.8010405@msgid.tls.msk.ru>
Date: Tue, 24 Mar 2009 16:36:04 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: tg3 driver fails to load firmware (2.6.29)
References: <20090324120948.GO12613@charite.de> <20090324121608.19f71ce2@lxorguk.ukuu.org.uk> <20090324122211.GS12613@charite.de> <20090324122900.06efc50d@lxorguk.ukuu.org.uk> <20090324123137.GV12613@charite.de> <20090324123229.GW12613@charite.de>
In-Reply-To: <20090324123229.GW12613@charite.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Hildebrandt wrote:
> * Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>:
>> * Alan Cox <alan@lxorguk.ukuu.org.uk>:
>>>>> Is your userspace configured to use /lib/firmware/2.6.29 or the more
>>>>> usual /lib/firmware/ ?
>>>> Which leads to the next question: How to I find out?
>>> Consult your distribution ? or stick it in both places and see 8)
>> Did that. No workee.
> 
> I mean, loading the firmware is not SOOO important. The thing that
> annoys me is the 60 delay introduced by that.

Damn.

I missed that thing in your initial message.
It's the delay.  It's here!

The thing is that you don't run any hotplug handler.
No udev or mdev.

Hence no on handles that firmware loading request.
Hence the kernel waits and times out...

Oh well.

/mjt
