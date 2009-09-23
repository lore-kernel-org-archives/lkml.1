Return-Path: <linux-kernel-owner+w=401wt.eu-S1752983AbZIWOCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbZIWOCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbZIWOCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:02:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:44143 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbZIWOCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:02:05 -0400
Message-ID: <4ABA2A3A.6020308@kernel.org>
Date: Wed, 23 Sep 2009 23:01:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Nick Piggin <npiggin@suse.de>, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ia64: allocate percpu area for cpu0 like percpu areas
 for other cpus
References: <1253605214-23210-1-git-send-email-tj@kernel.org> <1253605214-23210-3-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0909221856050.9410@V090114053VZO-1> <4AB983B6.6050203@kernel.org> <alpine.DEB.1.10.0909230941560.21821@V090114053VZO-1>
In-Reply-To: <alpine.DEB.1.10.0909230941560.21821@V090114053VZO-1>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 23 Sep 2009 14:01:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Christoph Lameter wrote:
> You did not answer my question.

Hmmm...

> The local percpu variables are accessed via a static per cpu
> virtual mapping. You cannot place per cpu variables outside of that
> virtual address range of PERCPU_PAGE_SIZE.
> 
> What happens if the percpu allocator allocates more data than available in
> the reserved area?

I still don't understand your question.  Static percpu variables are
always allocated from the first chunk inside that PERCPU_PAGE_SIZE
area.  Dynamic allocations can go outside of that but they don't need
any special handling.  What problems are you seeing?

-- 
tejun
