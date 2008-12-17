Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1755071AbYLQQDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbYLQQDX (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbYLQQDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:03:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44433 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbYLQQDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:03:12 -0500
Date: Wed, 17 Dec 2008 17:15:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org,
        tj@kernel.org
Subject: Re: [RFC] globmatch() helper function
Message-ID: <20081217161522.GF25779@one.firstfloor.org>
References: <20081217104247.28440.qmail@science.horizon.com> <87hc530w39.fsf@basil.nowhere.org> <1229526942.9487.75.camel@twins> <1229528856.30177.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229528856.30177.4.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I need to look at your code (I would like a generalized glob feature for
> user input). Can you accomplish the same with using a loop instead of
> recursion?

Standard * always requires a stack, it's a recursive problem unless
you change the semantics to non greedy. While you can open code the
stack it would be be easier to just limit the recursion.  Not more than 
10 or so should be plenty.

But the other problem is that Linux doesn't accept anonymous code 
contributions.

-Andi

-- 
ak@linux.intel.com
