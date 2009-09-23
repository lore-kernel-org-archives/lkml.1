Return-Path: <linux-kernel-owner+w=401wt.eu-S1752281AbZIWRUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbZIWRUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 13:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZIWRUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 13:20:53 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:60385 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750965AbZIWRUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 13:20:53 -0400
Date: Wed, 23 Sep 2009 13:17:10 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Tejun Heo <tj@kernel.org>
cc: Nick Piggin <npiggin@suse.de>, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ia64: allocate percpu area for cpu0 like percpu
 areas for other cpus
In-Reply-To: <4ABA2A3A.6020308@kernel.org>
Message-ID: <alpine.DEB.1.10.0909231315310.4025@V090114053VZO-1>
References: <1253605214-23210-1-git-send-email-tj@kernel.org> <1253605214-23210-3-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0909221856050.9410@V090114053VZO-1> <4AB983B6.6050203@kernel.org> <alpine.DEB.1.10.0909230941560.21821@V090114053VZO-1>
 <4ABA2A3A.6020308@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009, Tejun Heo wrote:

> any special handling.  What problems are you seeing?

per cpu variable access on IA64 does not use the percpu_offset for the
calculation of the current per cpu data area. Its using a virtual mapping.

How does the new percpu allocator support this? Does it use different
methods of access for static and dynamic percpu access?


