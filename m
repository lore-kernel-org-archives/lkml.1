Return-Path: <linux-kernel-owner+w=401wt.eu-S934664AbZKYM6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934664AbZKYM6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 07:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758763AbZKYM6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 07:58:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:47811 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758746AbZKYM6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 07:58:31 -0500
Message-ID: <4B0D29D9.1090809@kernel.org>
Date: Wed, 25 Nov 2009 21:58:01 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: linux-next: percpu tree build failure
References: <20091125234133.4d603f48.sfr@canb.auug.org.au>
In-Reply-To: <20091125234133.4d603f48.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

11/25/2009 09:41 PM, Stephen Rothwell wrote:
> Caused by commit 9a453506c3503929654112851e27b8c64c693912 ("percpu: Fix
> kdump failure if booted with percpu_alloc=page").  I reverted the merge
> commit (due to dependencies) that merged the above
> (25b1a9ccfdd0e3dc306a1e3a354ba5480c4b0dd9 "Merge branch 'for-linus' into
> for-next to receive per_cpu_ptr_to_phys ().") for today.  The branch
> being merged had only that one commit in it.

The change was missing asm/io.h include and the fix commit was
incorrectly attributed to me.  Fixed both problems.

Thanks.

-- 
tejun
