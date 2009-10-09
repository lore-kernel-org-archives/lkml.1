Return-Path: <linux-kernel-owner+w=401wt.eu-S1760581AbZJIJiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581AbZJIJiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760564AbZJIJiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:38:23 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:53407 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760553AbZJIJiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:38:21 -0400
Subject: Re: [PATCH 1/2] kmemleak: Use GFP_ATOMIC for early_alloc().
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091009093028.4365.4391.stgit@pc1117.cambridge.arm.com>
References: <20091009093028.4365.4391.stgit@pc1117.cambridge.arm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 09 Oct 2009 10:37:10 +0100
Message-Id: <1255081030.27873.37.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Oct 2009 09:37:11.0241 (UTC) FILETIME=[138F0390:01CA48C4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 10:30 +0100, Catalin Marinas wrote:
> We can't use GFP_KERNEL inside rcu_read_lock().
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

I mistakenly dropped the author information. The correct patch should
have a "From: Tetsuo" line. I'll re-post in reply to this message.

-- 
Catalin

