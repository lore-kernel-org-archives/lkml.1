Return-Path: <linux-kernel-owner+w=401wt.eu-S1752452AbZCKGsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbZCKGsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 02:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZCKGsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 02:48:20 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:49414 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZCKGsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 02:48:20 -0400
Message-ID: <49B75EAE.4080708@in.ibm.com>
Date: Wed, 11 Mar 2009 12:18:14 +0530
From: "Sachin P. Sant" <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-next@vger.kernel.org, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RESEND GIT PATCH tj-percpu] percpu: fix spurious alignment WARN
 in legacy SMP percpu allocator
References: <20090310195534.8f8f3c7a.sfr@canb.auug.org.au> <49B67552.5070307@in.ibm.com> <49B73B15.3040101@in.ibm.com> <49B75215.5010707@kernel.org>
In-Reply-To: <49B75215.5010707@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Impact: remove spurious WARN on legacy SMP percpu allocator
>
> Commit f2a8205c4ef1af917d175c36a4097ae5587791c8 incorrectly added too
> tight WARN_ON_ONCE() on alignments for UP and legacy SMP percpu
> allocator.  Commit e317603694bfd17b28a40de9d65e1a4ec12f816e fixed it
> for UP but legacy SMP allocator was forgotten.  Fix it.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Sachin P. Sant <sachinp@in.ibm.com>
> ---
Thanks. The patch fixes the warning.

Tested-by : Sachin Sant <sachinp@in.ibm.com>


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

