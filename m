Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704Ab0AWLfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab0AWLfx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 06:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541Ab0AWLfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 06:35:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43476 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab0AWLfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 06:35:52 -0500
Date: Sat, 23 Jan 2010 12:35:51 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Andi Kleen <andi@firstfloor.org>, Don Mullis <don.mullis@gmail.com>,
       linux-kernel@vger.kernel.org, airlied@redhat.com,
       dedekind@infradead.org
Subject: Re: [PATCH 1/2] lib: more scalable list_sort()
Message-ID: <20100123113551.GB29555@one.firstfloor.org>
References: <87fx609i29.fsf@gmail.com> <20100121175914.GA8910@basil.fritz.box> <87vdeu96bo.fsf@gmail.com> <87k4vah12u.fsf@basil.nowhere.org> <20100123082839.GB25842@discord.disaster>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100123082839.GB25842@discord.disaster>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Burning CPU time to save on IO is a very valid tradeoff in
> filesystem design - burning a few hundred millieseconds of CPU
> time can result in savcwinge tens of seconds of IO time. Hence
> passing big long lists to be sorted is not an indication of broken
> design, it's an indication of understanding CPU time vs IO time
> tradeoffs during design...

Burning long CPU time in kernel code without latency breaker code is always
a sign of broken design. When you burn you have to check for 
reschedules. It's that simple.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
