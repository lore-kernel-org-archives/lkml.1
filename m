Return-Path: <linux-kernel-owner+w=401wt.eu-S1762063AbYJJVLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063AbYJJVLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759599AbYJJVL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:11:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759490AbYJJVLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:11:25 -0400
Date: Fri, 10 Oct 2008 14:10:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [bug] latest -git boot hang
In-Reply-To: <20081010205642.GA28840@elte.hu>
Message-ID: <alpine.LFD.2.00.0810101408320.3503@nehalem.linux-foundation.org>
References: <20081010203043.GA11798@elte.hu> <20081010204015.GA15668@elte.hu> <20081010205642.GA28840@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Oct 2008, Ingo Molnar wrote:
> 
> | 870d6656126add8e383645732b03df2b7ccd4f94 is first bad commit
> | commit 870d6656126add8e383645732b03df2b7ccd4f94
> | Author: Tejun Heo <tj@kernel.org>
> | Date:   Mon Aug 25 19:47:25 2008 +0900
> |
> |     block: implement CONFIG_DEBUG_BLOCK_EXT_DEVT
> 
> and meanwhile 2 other test-systems failed to boot as well - both have 
> CONFIG_DEBUG_BLOCK_EXT_DEVT=y.
> 
> So i guess this debug feature is working as expected.

Ahh, yeah, sounds that way.

> I guess we should mark CONFIG_DEBUG_BLOCK_EXT_DEVT=y as really dangerous 
> to enable because contemporary distributions (i tried Fedora 9) fail 
> with it too?

Tejun - do you know whether _any_ distro will boot with 
CONFIG_DEBUG_BLOCK_EXT_DEVT=y?

It does sound like perhaps the option should be hidden more, if it's 
really only reasonably enabled for some very specialized distro debuggers, 
not normal kernel people.

			Linus
