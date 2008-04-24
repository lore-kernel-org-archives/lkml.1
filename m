Return-Path: <linux-kernel-owner+w=401wt.eu-S1759896AbYDXXXC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896AbYDXXXC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 19:23:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755609AbYDXXP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 19:15:29 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:59329 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759318AbYDXXP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 19:15:26 -0400
Message-ID: <481113FD.3010905@cs.columbia.edu>
Date: Thu, 24 Apr 2008 19:13:01 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Kirill Korotaev <dev@parallels.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Nadia.Derbey@bull.net,
       Andrew Morton <akpm@linux-foundation.org>, nick@nick-andrew.net,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: Checkpoint/restart (was Re: [PATCH 0/4] - v2 -  Object	creation
 with a specified id)
References: <20080418054459.891481000@bull.net>	<20080422193612.GA15835@martell.zuzino.mipt.ru>	<1208890580.17117.14.camel@nimitz.home.sr71.net>	<20080422210130.GA15937@martell.zuzino.mipt.ru>	<1208904967.17117.51.camel@nimitz.home.sr71.net>	<480ED9D5.1010906@parallels.com>	<1208964798.17117.72.camel@nimitz.home.sr71.net>	<48103002.5090806@parallels.com> <1209061809.12718.36.camel@nimitz.home.sr71.net>
In-Reply-To: <1209061809.12718.36.camel@nimitz.home.sr71.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dave Hansen wrote:
> On Thu, 2008-04-24 at 11:00 +0400, Kirill Korotaev wrote:
>> Yeah... we talked with Andrew yesterday. He mostly agrees with a black
>> box.
>> He also said an interesting idea, that if you need compatibility
>> between the kernels (like we for example, support for migration from
>> 2.6.9 to 2.6.18 in OpenVZ)
>> you can do image conversion in user-space...
> 
> That sounds compelling to me.  I'm definitely willing to explore it.

Filtering/converting in user-space has long been part of zap: used to
be able to migrate between both minor and major versions of the kernel
(always upwards, of course).

In fact, I already proposed it as part of the original thread that led
eventually to the patch in question:
https://lists.linux-foundation.org/pipermail/containers/2008-February/009849.html

The need to be able to specify a desired ID (from user-space and/or from
in-kernel) remains.

Oren.

> Any thoughts on what we should start with?  What can we get merged, most
> easily?
> 
> -- Dave
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
