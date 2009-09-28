Return-Path: <linux-kernel-owner+w=401wt.eu-S1752046AbZI1EbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbZI1EbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 00:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbZI1EbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 00:31:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:60770 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751398AbZI1EbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 00:31:06 -0400
X-Authenticated: #404998
X-Provags-ID: V01U2FsdGVkX19hOzxTEClhfzrCyByDYLjc1MhSMIT1ucMAM5ficQ
	aG1YegqBbEpQ2I
Message-ID: <4AC03C09.7090008@gmx.net>
Date: Mon, 28 Sep 2009 06:31:05 +0200
From: Martin Wache <m.wache@gmx.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Status of Regression/Bug 13407 adb trackpad disappears after
 suspend to ram?
References: <4ABF5432.9020508@gmx.net> <200909271713.44719.rjw@sisk.pl>	 <4ABFAA82.2040200@gmx.net> <1254108467.8421.3.camel@pasglop>
In-Reply-To: <1254108467.8421.3.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt schrieb:
> On Sun, 2009-09-27 at 20:10 +0200, Martin Wache wrote:
>> Hi,
>>
>> Rafael J. Wysocki schrieb:
>>
>>> A patch has been submitted which is reported to fix the issue:
>>>
>>> http://patchwork.kernel.org/patch/49462/
>>>
>>> Please test it as requested.
>>>
>> Thank you for the info :-)
>>
>> Unfortunately, applying the patch on top of 2.6.31 doesn't improve the 
>> situation for me, rather the opposite. Under X I get no reaction on any 
>>   keypress on the keyboard or movement on the trackpad. Even plugging in 
>> an USB mouse and keyboard didn't help, the usb port doesn't provide an 
>> power to the mouse (at least the led in the mouse doesn't light up).
>> Before X starts up the keyboard does respond, also the trackpad seems to 
>> be detected. Doing a suspend/resume cycle doesn't change the situation.
> 
> That looks like a different problem than the one I fixed. Is there an
> email thread or a bugzilla entry that describes the setup precisely, the
> symptoms, kernel logs etc... ?
> 
The USB not working was indeed a separate issue, I striped down my 
kernel config before building 2.6.31 and striped it down too much. After 
fixing the config the usb is again working.

What I don't really understand is that now after I fixed the usb kernel 
config and recompiled also the adb keyboard and trackpad are working again.
To test the original issue, I did several suspend/resume cycles and my 
trackpad is still working :-).
Without the patch the trackpad was almost never working after a 
suspend/resume cycle, so the adb trackpad issue seems to be fixed with 
your patch.
Thank you very much :-)

Bye,

Martin
