Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbYHTOLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbYHTOLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 10:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbYHTOLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 10:11:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752975AbYHTOLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:11:04 -0400
Message-ID: <48AC25E7.4090005@linux-foundation.org>
Date: Wed, 20 Aug 2008 09:10:47 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       tokunaga.keiich@jp.fujitsu.com
Subject: Re: [RFC][PATCH 0/2] Quicklist is slighly problematic.
References: <20080820195021.12E7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080820195021.12E7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi Cristoph,
> 
> Thank you for explain your quicklist plan at OLS.
> 
> So, I made summary to issue of quicklist.
> if you have a bit time, Could you please read this mail and patches?
> And, if possible, Could you please tell me your feeling?

I believe what I said at the OLS was that quicklists are fundamentally crappy
and should be replaced by something that works (Guess that is what you meant
by "plan"?). Quicklists were generalized from the IA64 arch code.

Good fixup but I would think that some more radical rework is needed.

Maybe some of this needs to vanish into the TLB handling logic?

Then I have thought for awhile that the main reason that quicklists exist are
the performance problems in the page allocator. If you can make the single
page alloc / free pass competitive in performance with quicklists then we
could get rid of all uses.





