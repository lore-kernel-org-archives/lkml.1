Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbZLBKO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbZLBKO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 05:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbZLBKO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 05:14:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:45203 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbZLBKO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 05:14:28 -0500
Message-ID: <4B163DEA.2050303@kernel.org>
Date: Wed, 02 Dec 2009 19:14:02 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, peterz@infradead.org,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] sched: refactor try_to_wake_up()
References: <1259726212-30259-1-git-send-email-tj@kernel.org>	 <1259726212-30259-4-git-send-email-tj@kernel.org>	 <1259744733.6028.233.camel@marge.simson.net>  <4B16388F.90707@kernel.org> <1259748618.6028.282.camel@marge.simson.net>
In-Reply-To: <1259748618.6028.282.camel@marge.simson.net>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2009 07:10 PM, Mike Galbraith wrote:
>>> I think it would _look_ better with the thing just
>>> duplicated/stripped down and called what it is,
>>> sched_notifier_wakeup() or such.
>>
>> Sorry, I'm not following.  Can you elaborate a bit?
> 
> I mean copying ttwu, stripping out locking etc, and renaming the result
> would look better.  No functional difference though, and binary growth
> would be left in the wake of such a duplication.

Ah... okay.  Well, that was the first approach (with some missing
parts).  Peter wasn't particularly happy with code duplication and
suggested refactoring ttwu and reuse common parts.

Thanks.

-- 
tejun
