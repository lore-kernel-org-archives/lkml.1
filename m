Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbXLLDLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbXLLDLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 22:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbXLLDLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 22:11:08 -0500
Received: from host06.hostingexpert.com ([216.80.70.60]:52236 "EHLO
	host06.hostingexpert.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbXLLDLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 22:11:07 -0500
X-Greylist: delayed 3331 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2007 22:11:07 EST
Message-ID: <475F513F.2010504@linuxtv.org>
Date: Tue, 11 Dec 2007 22:10:55 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB fixes
References: <1197424531.9563.6.camel@gaivota> <475F4422.6050000@linuxtv.org>	 <1197426798.9563.15.camel@gaivota> <1197426998.9563.18.camel@gaivota>
In-Reply-To: <1197426998.9563.18.camel@gaivota>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host06.hostingexpert.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linuxtv.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
>>> ^^ This patch fixes a build issue that only applies to new devices
>>>       
>> that
>>     
>>> depend on the tuner-xc2028 module, which is planned to be added to
>>> mainline for 2.6.25 ....  We don't need to send this patch upstream yet,
>>> because the dependency doesn't exist in 2.6.24.
>>>       
>> Hmm... ok. Anyway, It won't hurt to apply it. The patch just adds a
>> missing include directory to Makefile:
>> +EXTRA_CFLAGS += -Idrivers/media/video
>>
>> Anyway, I'll remove it from the tree and send to linus an updated pull
>> request.
>>     
>
> Linus already pulled from my tree. There's no need to revert this
> changeset. It will not hurt and will be needed soon, anyway.
>   
That's fine -- it doesn't hurt anything.

Cheers,

Mike
