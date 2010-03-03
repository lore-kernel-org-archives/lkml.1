Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab0CCRtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:49:19 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:37795 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab0CCRtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:49:15 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B8EA192.5070108@cam.ac.uk>
Date: Wed, 03 Mar 2010 17:51:14 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dima Zavin <dmitriyz@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
References: <4B8C1867.7040201@cam.ac.uk> <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com> <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'ing Input list and maintainer.
> 
> On Tue, 2 Mar 2010, Dima Zavin wrote:
>>
>> I definitely see the need for what you guys are trying to accomplish.
>> For example, currently, we use an input device for reporting events,
>> and a separate misc device node for control
>> (enable/disable/configure). It's definitely suboptimal, but there
>> currently isn't anything there would let us do things cleanly.
> 
> I have to say, I personally don't see why something like an ambient light 
> sensor _isn't_ just an input device. 
> 
> What's the difference between a physical "increase screen brightness" key, 
> and a "ambient light sensor"? Absolutely none as far as I can tell.
> 
> And for something like an X server, it sounds a lot more natural to just 
> have another input device than to have yet abother event reporting 
> interface.
> 
> And quite frankly, the "explanations" I see in this thread for why it 
> needs to be a subsystem of its own don't actually explain anything or make 
> sense. They seem to boil down to "we just did it this way" without 
> actually answering any of the issues brought up.
> 
> 		Linus
> 

