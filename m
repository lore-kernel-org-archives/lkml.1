Return-Path: <linux-kernel-owner+w=401wt.eu-S970390AbXILRoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970390AbXILRoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969325AbXILRm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:42:57 -0400
Received: from smtp.nokia.com ([131.228.20.170]:40769 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968309AbXILRmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:42:55 -0400
X-Greylist: delayed 2567 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Sep 2007 13:42:54 EDT
Message-ID: <46E81B06.4010504@nokia.com>
Date: Wed, 12 Sep 2007 19:59:50 +0300
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
X-OriginalArrivalTime: 12 Sep 2007 16:59:52.0005 (UTC) FILETIME=[55E37750:01C7F55E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

ext Andi Kleen wrote:
> 
>> So what can we do about the clflush on this CPU?
> 
> I'll just remove that CLFLUSH statement. It was just supposed
> to be an optimization, but is not strictly needed.

2.6.23-rc6 boots up fine on my box. Regression fixed. Thanks.

Regards,

	Stefan

---
Stefan Becker
E-Mail: Stefan.Becker@nokia.com
