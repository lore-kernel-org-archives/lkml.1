Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYDZJvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYDZJvi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 05:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbYDZJv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 05:51:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60820 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbYDZJv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 05:51:29 -0400
Date: Sat, 26 Apr 2008 11:51:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, arjan@linux.intel.com,
       Dave Airlie <airlied@linux.ie>
Subject: Re: [PATCH] x86: create array based interface to chagne page
	attribute
Message-ID: <20080426095115.GA15212@elte.hu>
References: <1209202037-6513-1-git-send-email-airlied@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209202037-6513-1-git-send-email-airlied@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Airlie <airlied@redhat.com> wrote:

> From: Dave Airlie <airlied@linux.ie>
> 
> When cpa was refactored to the new set_memory_ interfaces, it removed 
> a special case fast path for AGP systems, which did a lot of page by 
> page attribute changing and held the flushes until they were finished. 
> The DRM memory manager also required this to get useable speeds.
> 
> This introduces a new interface, which accepts an array of memory 
> addresses to have attributes changed on and to flush once finished.
> 
> Further changes to the AGP stack to actually use this interface will 
> be published later.

thanks Dave, applied.

	Ingo
