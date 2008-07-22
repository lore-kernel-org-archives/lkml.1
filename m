Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbYGVSdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbYGVSdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYGVSdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:33:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37247 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbYGVSdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:33:14 -0400
Message-ID: <488627E2.2060101@garzik.org>
Date: Tue, 22 Jul 2008 14:33:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Ivan Seskar <Seskar@winlab.rutgers.edu>, jfm3 <jfm3@winlab.rutgers.edu>,
       Sujith <m.sujith@gmail.com>
Subject: Re: Bug on 2.6.26 - x86 VIA Nehemiah CentaurHauls processor cannot
 boot
References: <43e72e890807210614y58065d75j5b2fb3c5ebe6180a@mail.gmail.com>	 <48848DDF.6010903@zytor.com>	 <43e72e890807210701w6d7f5638w5fdbea76a1cf1c0b@mail.gmail.com>	 <48851AC2.8030007@zytor.com> <43e72e890807212147p5d19cfact17e719abb338378c@mail.gmail.com> <488614A3.1060400@garzik.org> <48862526.7060704@zytor.com>
In-Reply-To: <48862526.7060704@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeff Garzik wrote:
>>>
>>> Thanks for taking a  look at this. So well, it would be a
>>> misconfiguration bug by the distribution then to try to support a
>>> generic 686 kernel wihtout GENERIC then.
>>
>> Well, it may be intentional -- some distros simply exclude support for 
>> the lower-volume VIA processors, since that might imply building their 
>> "generic 686 kernel" sans CMOV and some other instructions, and 
>> changing the compiler's instruction scheduling to something less 
>> optimal for the majority.  :/
>>
> 
> X86_GENERIC shouldn't disable CMOV?

I said "generic 686 kernel" not a specific Kconfig option (for reasons 
stated below), which is a bit different.


> We're only referring specifically to the family == 6 VIA processors here.

To be specific, I was merely saying that VIA processors where 
c->x86_model==6 may lack CMOV.

I have not kept track of what current Kconfig options will set, but in 
the past it was quite easy to build a "generic 686 kernel" that required 
CMOV and thus excluded these VIA processors.

Distros in the past often wound up intentionally -not- supporting some 
of these VIA processors, because they did not want to create a non-CMOV 
kernel.  (This policy obviously excluded older x86 as well)

If these things have been addressed recently (< 12-18 months) then all good.

	Jeff




