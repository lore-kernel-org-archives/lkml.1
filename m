Return-Path: <linux-kernel-owner+w=401wt.eu-S1751321AbXBMWA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbXBMWA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbXBMWA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:00:59 -0500
Received: from comtv.ru ([217.10.32.17]:54920 "EHLO comtv.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbXBMWA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:00:58 -0500
X-UCL: actv
Date: Wed, 14 Feb 2007 01:01:26 +0300 (MSK)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@home.oyster.ru
To: Pavel Machek <pavel@ucw.cz>
cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: CPU load
In-Reply-To: <20070212143219.GB5226@ucw.cz>
Message-ID: <Pine.LNX.4.64.0702140059390.727@home.oyster.ru>
References: <loom.20070212T063225-663@post.gmane.org>
 <8cd998d50702112144y38958d27saec4196f6f5d5236@mail.gmail.com>
 <20070212143219.GB5226@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Feb 2007, Pavel Machek wrote:

> Hi!
>
>> The kernel looks at what is using cpu _only_ during the
>> timer
>> interrupt. Which means if your HZ is 1000 it looks at
>> what is running
>> at precisely the moment those 1000 timer ticks occur. It
>> is
>> theoretically possible using this measurement system to
>> use >99% cpu
>> and record 0 usage if you time your cpu usage properly.
>> It gets even
>> more inaccurate at lower HZ values for the same reason.
>
> I have (had?) code that 'exploits' this. I believe I could eat 90% of cpu
> without being noticed.

Slightly changed version of hog(around 3 lines in total changed) does that
easily on 2.6.18.3 on PPC.

http://www.boblycat.org/~malc/apc/load-hog-ppc.png

-- 
vale
