Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1755417AbYLQQjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbYLQQjp (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbYLQQjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:39:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41100 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbYLQQjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:39:35 -0500
Date: Wed, 17 Dec 2008 17:51:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, George Spelvin <linux@horizon.com>,
        peterz@infradead.org, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] globmatch() helper function
Message-ID: <20081217165149.GG25779@one.firstfloor.org>
References: <20081217104247.28440.qmail@science.horizon.com> <87hc530w39.fsf@basil.nowhere.org> <1229526942.9487.75.camel@twins> <20081217160417.18507.qmail@science.horizon.com> <49492733.9000108@kernel.org> <1229531466.30177.12.camel@localhost.localdomain> <494929E5.8060302@kernel.org> <1229531826.30177.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229531826.30177.14.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, lets compromise with WARN_ON_ONCE() ;-)

I don't think WARN_ON is the right way to handle bad user input.
It implies that when someone typos the result might end up in Arjan's 
kerneloops.org database, which is not good.

-Andi
-- 
ak@linux.intel.com
