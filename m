Return-Path: <linux-kernel-owner+w=401wt.eu-S933406AbYGQXWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406AbYGQXWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932288AbYGQXVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:21:16 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:47721 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116AbYGQXVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:21:15 -0400
Message-ID: <487FD251.9090204@cs.columbia.edu>
Date: Thu, 17 Jul 2008 19:14:25 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Kirill Korotaev <dev@parallels.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Nadia.Derbey@bull.net, Andrew Morton <akpm@linux-foundation.org>,
       nick@nick-andrew.net, Alexey Dobriyan <adobriyan@gmail.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: Checkpoint/restart (was Re: [PATCH 0/4] - v2 - Object creation
 with a specified id)
References: <20080418054459.891481000@bull.net>	 <20080422193612.GA15835@martell.zuzino.mipt.ru>	 <1208890580.17117.14.camel@nimitz.home.sr71.net>	 <20080422210130.GA15937@martell.zuzino.mipt.ru>	 <1208904967.17117.51.camel@nimitz.home.sr71.net>	 <480ED9D5.1010906@parallels.com> <480FE037.2010302@cs.columbia.edu>	 <m1y74a7b4w.fsf@frodo.ebiederm.org> <1215709949.9398.15.camel@nimitz>
In-Reply-To: <1215709949.9398.15.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dave Hansen wrote:
> On Wed, 2008-07-09 at 18:58 -0700, Eric W. Biederman wrote:
>> In the worst case today we can restore a checkpoint by replaying all of
>> the user space actions that took us to get there.  That is a tedious
>> and slow approach.
> 
> Yes, tedious and slow, *and* minimally invasive in the kernel.  Once we
> have a tedious and slow process, we'll have some really good points when

"Replaying all of the user space actions that took us to get there" -
this task is not even always possible without deterministic log/replay
mechanism :(

Oren.

> we try to push the next set of patches to make it less slow and tedious.
> We'll be able to describe an _actual_ set of problems to our fellow
> kernel hackers.
> 
> So, the checkpoint-as-a-corefile idea sounds good to me, but it
> definitely leaves a lot of questions about exactly how we'll need to do
> the restore.
> 
> -- Dave
> 
