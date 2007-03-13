Return-Path: <linux-kernel-owner+w=401wt.eu-S933776AbXCMWQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776AbXCMWQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 18:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933775AbXCMWQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 18:16:52 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:55993 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933779AbXCMWQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 18:16:51 -0400
Message-ID: <45F722CE.9000602@gmail.com>
Date: Tue, 13 Mar 2007 23:16:46 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: johann deneux <johann.deneux@gmail.com>
CC: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz,
       "Anssi Hannula" <anssi.hannula@gmail.com>
Subject: FF layer restrictions [Was: [PATCH 1/1] Input: add sensable phantom
 driver]
References: <2460126662758025813@fi.muni.cz>	 <d120d5000703070647t223f8858i8c495dcc3e1378a2@mail.gmail.com>	 <45EEEAA3.50009@gmail.com>	 <d120d5000703070856of068f19k62c5a7ce1f829336@mail.gmail.com>	 <4af2d03a0703130919nb4893b1ja9ec795dcf4bf53c@mail.gmail.com> <38b3b7c0703131450v2646e63fj2be4b9dda7f928c0@mail.gmail.com>
In-Reply-To: <38b3b7c0703131450v2646e63fj2be4b9dda7f928c0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 13 Mar 2007 23:16:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Why did you remove all Cced people? Anyway I filtered some of them out

johann deneux napsal(a):
> You are right, the direction in ff_effect is meant to be an angle.
> A dirty solution would be to use the 16 bits as two 8-bits angles. Or 

That would be a problem as I need 3x 16bits.

> maybe we should change the API. I don't think there are many 
> applications using force feedback yet, so maybe that should be ok?
> 
> If we change the API, we should remove the assumption that a device has 
> at most two axes to render effects. We could for instance have a 
> magnitude argument for each axis which is capable of rendering effects. 
> That might be necessary even for more common gaming devices like racing 
> wheels: One can think pedals could also be capable of force feedback 
> some day, not just the steering wheel.

I can do that, but in that case, I need to know how people (especially those 
input one) want me to do...

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
