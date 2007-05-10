Return-Path: <linux-kernel-owner+w=401wt.eu-S1759789AbXEJSoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759789AbXEJSoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 14:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbXEJSn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 14:43:57 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:35041 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689AbXEJSn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 14:43:57 -0400
Date: Thu, 10 May 2007 20:41:05 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: Chaining sg lists for big I/O commands: Question
In-Reply-To: <20070509133830.GV4163@kernel.dk>
Message-ID: <Pine.LNX.4.61.0705102040090.6426@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0705090918390.12857@p34.internal.lan>
 <20070509133830.GV4163@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 9 2007 15:38, Jens Axboe wrote:
>> I am a mdadm/disk/hard drive fanatic, I was curious:
>> 
>> >On i386, we can at most fit 256 scatterlist elements into a page,
>> >and on x86-64 we are stuck with 128. So that puts us somewhere
>> >between 512kb and 1024kb for a single IO.
>> 
>> How come 32bit is 256 and 64 is only 128?
>>
>> I am sure it is something very fundamental/simple but I was curious, I 
>> would think x86_64 would fit/support more scatterlists in a page.
>
>Because of the size of the scatterlist structure. As pointers are bigger
>on 64-bit archs, the scatterlist structure ends up being bigger. The
>page size on x86-64 is 4kb, hence the number of structures you can fit
>in a page is smaller.

I take it this problem "goes away" on arches with 8KB page_size?


	Jan
-- 
