Return-Path: <linux-kernel-owner+w=401wt.eu-S1751473AbZI0SKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbZI0SKO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 14:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbZI0SKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 14:10:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:52114 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750841AbZI0SKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 14:10:12 -0400
X-Authenticated: #404998
X-Provags-ID: V01U2FsdGVkX1+t8aFPUt2tBU+5PR2Zd7WByHSdf06zS3xrr/B1pg
	4DRnLJ3/uT0cNg
Message-ID: <4ABFAA82.2040200@gmx.net>
Date: Sun, 27 Sep 2009 20:10:10 +0200
From: Martin Wache <m.wache@gmx.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Status of Regression/Bug 13407 adb trackpad disappears after
 suspend to ram?
References: <4ABF5432.9020508@gmx.net> <200909271713.44719.rjw@sisk.pl>
In-Reply-To: <200909271713.44719.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Rafael J. Wysocki schrieb:

> A patch has been submitted which is reported to fix the issue:
> 
> http://patchwork.kernel.org/patch/49462/
> 
> Please test it as requested.
>
Thank you for the info :-)

Unfortunately, applying the patch on top of 2.6.31 doesn't improve the 
situation for me, rather the opposite. Under X I get no reaction on any 
  keypress on the keyboard or movement on the trackpad. Even plugging in 
an USB mouse and keyboard didn't help, the usb port doesn't provide an 
power to the mouse (at least the led in the mouse doesn't light up).
Before X starts up the keyboard does respond, also the trackpad seems to 
be detected. Doing a suspend/resume cycle doesn't change the situation.

I'm not sure if there was a miscompilation, I didn't do a "make clean", 
I just applied the patch and did a "make". Should this be enough? 
Compiling the whole kernel unfortunately takes quite a while on my iBook :-(
I will see if I can connect to the iBook via net and get some 
information on what is happening, or maybe I try to start it up without 
X. Would it help you if I send you the logs, etc? Which information 
would help you?

Thanks,

Martin

