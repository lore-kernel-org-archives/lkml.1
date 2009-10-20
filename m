Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbZJTHf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbZJTHf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 03:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbZJTHf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 03:35:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:42301 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509AbZJTHfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 03:35:25 -0400
Message-ID: <4ADD686D.9070603@kernel.org>
Date: Tue, 20 Oct 2009 16:36:13 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Ingo Molnar <mingo@elte.hu>, Jeff Mahoney <jeffm@suse.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org
Subject: Re: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
References: <4ADB967A.4080707@suse.com> <alpine.LRH.2.00.0910200356340.20992@twin.jikos.cz> <alpine.LRH.2.00.0910200651510.20992@twin.jikos.cz> <20091020061557.GE8550@elte.hu> <alpine.LSU.2.00.0910200820500.8582@wotan.suse.de> <20091020063555.GJ8550@elte.hu> <4ADD62CD.3080208@kernel.org> <alpine.LSU.2.00.0910200915510.8582@wotan.suse.de>
In-Reply-To: <alpine.LSU.2.00.0910200915510.8582@wotan.suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 20 Oct 2009 07:35:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Tue, 20 Oct 2009, Tejun Heo wrote:
> 
>> Extending the first chunk size shouldn't be difficult on ia64 but other 
>> than this, there still is a lot of room left with the current 64k limit, 
>> so I think we should be safe for a while.  BTW, I also am curious how 
>> lockdep has been coping with the limit.
> 
> There is no lockdep on ia64, and we don't have such restriction on .percpu 
> section on any other architecture which supports lockdep, right?

Yeap, the restriction is only on ia64.

-- 
tejun
