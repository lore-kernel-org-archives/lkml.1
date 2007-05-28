Return-Path: <linux-kernel-owner+w=401wt.eu-S1763044AbXE1TD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763044AbXE1TD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 15:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758049AbXE1TDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 15:03:50 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:58546 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbXE1TDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 15:03:49 -0400
Date: Mon, 28 May 2007 21:03:00 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Tilman Schmidt <tilman@imap.cc>
cc: "Lars K.W. Gohlke" <lkwg82@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
In-Reply-To: <465B0BC9.2040502@imap.cc>
Message-ID: <Pine.LNX.4.61.0705282036030.11140@yvahk01.tjqt.qr>
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de>
 <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr> <4648E9F7.5090908@imap.cc>
 <Pine.LNX.4.61.0705151020310.9570@yvahk01.tjqt.qr> <46536C0F.50101@imap.cc>
 <4655676A.1000102@gmx.de> <4655C554.7030000@imap.cc> <4655C93D.40005@gmx.de>
 <Pine.LNX.4.61.0705241927410.31549@yvahk01.tjqt.qr> <4655E463.7000201@gmx.de>
 <465B0BC9.2040502@imap.cc>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 28 2007 19:05, Tilman Schmidt wrote:
>Am 24.05.2007 21:15 schrieb Lars K.W. Gohlke:
>> Jan Engelhardt schrieb:
>[code proposal]
>>> [I've warned about it... ;-) ]
>> 
>> is it the way to access from kernelspace the userspace fs?
>> the not-correct-way?
>
>Yes, indeed.
>
>> If it is so, I will wait for another solution ;)
>
>I'm not sure waiting will help. The roasted pigeons will not come
>flying into your mouth.
>
>The possible solutions have been sketched out for you:
>
>a) open the device file from the kernel (described by Jan):
>   actively discouraged by the kernelnewbies.org FAQ document,
>   and probably won't even work IMHO

It does work. "It just needs work." :)
See https://dev.computergmbh.de/svn/quad_dsp/trunk/ for an example.



	Jan
-- 
