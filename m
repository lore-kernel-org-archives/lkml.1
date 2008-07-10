Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbYGJNRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbYGJNRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 09:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbYGJNRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 09:17:19 -0400
Received: from chrocht.moloch.sk ([62.176.169.44]:38056 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659AbYGJNRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:17:18 -0400
Message-ID: <48760BFB.90007@fastmq.com>
Date: Thu, 10 Jul 2008 15:17:47 +0200
From: Martin Sustrik <sustrik@fastmq.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, Martin Lucina <mato@kotelna.sk>,
       linux-kernel@vger.kernel.org
Subject: Re: Higher than expected disk write(2) latency
References: <20080628121131.GA14181@nodbug.moloch.sk>	<20080709222701.8eab4924.akpm@linux-foundation.org>	<4875C45C.2010901@fastmq.com> <20080710093109.46db7c40@the-village.bc.nu>
In-Reply-To: <20080710093109.46db7c40@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

>> What we see is that AIO performs rather bad while we are still 
>> enqueueing more writes (it misses right position on the disk and has to 
>> do superfluous disk revolvings), however, once we stop enqueueing new 
>> write request, those already in the queue are processed swiftly.
> 
> Which disk scheduler are you using - some of the disk schedulers
> intentionally delay writes to try and get better block merging.

It's CFQ. Does it delay writes? And if so, what should we use instead?

Thanks.
Martin
