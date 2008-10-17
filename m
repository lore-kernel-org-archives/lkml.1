Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYJQFnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYJQFnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 01:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYJQFnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 01:43:41 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:4222 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013AbYJQFnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 01:43:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqwEAM8S9kg7p+/x/2dsb2JhbACBcsA0gWs
X-IronPort-AV: E=Sophos;i="4.33,429,1220193000"; 
   d="scan'208";a="212716909"
Message-ID: <48F83400.90901@call-direct.com.au>
Date: Fri, 17 Oct 2008 16:43:12 +1000
From: Iwo Mergler <iwo@call-direct.com.au>
User-Agent: Thunderbird 2.0.0.12 (X11/20080302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Jes Sorensen <jes@trained-monkey.org>
Subject: Fix for genalloc locking
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I hit a little problem while using genalloc with a mix
of interrupt/non-interrupt context. I believe the correct
fix is to replace the locking calls with the _irqsave/_irqrestore
variants. Patch follows.

Is this correct?

BTW, is there any documentation on the Lockdep warnings?
What exactly is the meaning of {--+.} in 

(&pool->lock){--+.}, at: [<c0125d1c>] gen_pool_free+0x34/0x120


Kind regards,

Iwo

