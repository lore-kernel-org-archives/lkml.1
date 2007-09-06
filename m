Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbXIFOVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbXIFOVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 10:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbXIFOUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 10:20:53 -0400
Received: from smtp.nokia.com ([131.228.20.173]:53240 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbXIFOUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 10:20:52 -0400
Message-ID: <46E00C60.7040107@nokia.com>
Date: Thu, 06 Sep 2007 17:19:12 +0300
From: Stefan Becker <Stefan.Becker@nokia.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: ext Andi Kleen <andi@firstfloor.org>
CC: ext Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, davej@codemonkey.org.uk
Subject: Re: [pre-2.6.23 REGRESSION] 2.6.23-rc3-git1 crash/stuck on VIA CN700
 system
References: <46C9D148.5080505@nokia.com> <p734pibbbex.fsf@bingen.suse.de> <46DDA366.8090806@nokia.com> <20070905102525.GB31880@one.firstfloor.org> <46DECDC9.9050407@nokia.com> <20070905163724.GC31880@one.firstfloor.org> <46DF0257.5050303@nokia.com> <20070906053654.GD31880@one.firstfloor.org>
In-Reply-To: <20070906053654.GD31880@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Sep 2007 14:20:17.0103 (UTC) FILETIME=[0C52DDF0:01C7F091]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

ext Andi Kleen wrote:
>> This kernel boots up OK. Looking at the preprocessed C code the 
> 
> I assume you tested it a few times to make sure it really was the 
> problem? Perhaps reenable it also once again and see if it hangs
> again just to be sure.

I booted each kernel at least 5 times:

kernel-2.6.23-rc5-git WITH clflush:      always crashes
kernel-2.6.23-rc5-git WITHOUT clflush:   always boots

The only difference between the two kernels is the commented line in 
alternative.c/text_poke().

Regards,

	Stefan

---
Stefan Becker
E-Mail: Stefan.Becker@nokia.com
