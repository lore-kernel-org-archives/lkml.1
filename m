Return-Path: <linux-kernel-owner+w=401wt.eu-S1760168AbZKZJQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbZKZJQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760147AbZKZJQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:16:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:43885 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760066AbZKZJQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:16:04 -0500
Message-ID: <4B0E4741.10509@kernel.org>
Date: Thu, 26 Nov 2009 18:15:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the workqueues tree with the tip
 tree
References: <20091126190018.88a6dd77.sfr@canb.auug.org.au> <20091126081237.GA31034@elte.hu>
In-Reply-To: <20091126081237.GA31034@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11/26/2009 05:12 PM, Ingo Molnar wrote:
> Please submit scheduler patches to the scheduler tree. Such level of 
> refactoring of a critical scheduler component needs to go through the 
> regular scheduler channels. This is a frequently modified piece of code 
> and conflicts are likely in the future.

Sure, which sched/* branch should I base these patches on?
Alternatively, pulling the following branch into one of sched/* should
do the trick too.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-sched

Thanks.

-- 
tejun
