Return-Path: <linux-kernel-owner+w=401wt.eu-S1752636Ab0AXU7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab0AXU7Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 15:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058Ab0AXU7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 15:59:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40251 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab0AXU7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 15:59:12 -0500
Date: Sun, 24 Jan 2010 21:59:06 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Andi Kleen <andi@firstfloor.org>, Don Mullis <don.mullis@gmail.com>,
       linux-kernel@vger.kernel.org, airlied@redhat.com,
       dedekind@infradead.org
Subject: Re: [PATCH 1/2] lib: more scalable list_sort()
Message-ID: <20100124205906.GC29555@one.firstfloor.org>
References: <87fx609i29.fsf@gmail.com> <20100121175914.GA8910@basil.fritz.box> <87vdeu96bo.fsf@gmail.com> <87k4vah12u.fsf@basil.nowhere.org> <20100123082839.GB25842@discord.disaster> <20100123113551.GB29555@one.firstfloor.org> <20100123160537.GG25842@discord.disaster>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100123160537.GG25842@discord.disaster>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Similarly, adding cond_resched() to list_sort means you can stop
> worrying about the scheduling latency impact of sorting long lists.
> I fail to see why you're making such a big deal out of this.....

It's not easy to add it to a low level library function like list_sort()
because you would need to ensure that all callers are allowed to sleep.

Or even if all callers currently allow it future ones might not.

So it would need a new flag or so if needed, completely changing 
the interface.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
