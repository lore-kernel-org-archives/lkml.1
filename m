Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbZLJOOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbZLJOOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 09:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760851AbZLJOOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 09:14:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760830AbZLJOOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 09:14:10 -0500
Message-ID: <4B210212.8090008@redhat.com>
Date: Thu, 10 Dec 2009 12:13:38 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: "David T. L. Wong" <davidtlwong@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [GIT PULL for 2.6.33] V4L/DVB updates
References: <20091209021639.14f08856@pedra> <20091210062015.GA29594@elte.hu> <4B209D90.6080404@gmail.com>
In-Reply-To: <4B209D90.6080404@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David T. L. Wong wrote:
> Ingo Molnar wrote:
>> Hi,
>>
>> FYI, there's a new build failure on 32-bit x86 caused by the new
>> max2165 tuner driver:
>>
>> drivers/built-in.o: In function `max2165_set_params':
>> max2165.c:(.text+0x486293): undefined reference to `__floatunsidf'
>> max2165.c:(.text+0x4862bc): undefined reference to `__floatunsidf'
>> max2165.c:(.text+0x4862c5): undefined reference to `__adddf3'
>> max2165.c:(.text+0x4862cf): undefined reference to `__fixunsdfsi'
>>
>>     Ingo
> 
> 
> A patch is already submitted to v4l mailing list:
> http://patchwork.kernel.org/patch/64538/

Hmm... Douglas put this patch on his tree, but didn't submit me a pull
request yet.

I'll merge it right now and make it available for -git push soon.

Mauro.
