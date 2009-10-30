Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbZJ3KDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbZJ3KDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 06:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbZJ3KDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 06:03:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:39458 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074AbZJ3KDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 06:03:23 -0400
Message-ID: <4AEAB9B1.4000304@kernel.org>
Date: Fri, 30 Oct 2009 11:02:25 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: linux-next: manual merge of the percpu tree with Linus' tree
References: <20091030192050.06a0f706.sfr@canb.auug.org.au>
In-Reply-To: <20091030192050.06a0f706.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the percpu tree got a conflict in mm/percpu.c
> between commit 403a91b1659cb149dbddc5885f892734ae4542d8 ("percpu: allow
> pcpu_alloc() to be called with IRQs off") from Linus' tree and commit
> 0f5e4816dbf38ce9488e611ca2296925c1e90d5e ("percpu: remove some sparse
> warnings") from the percpu tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

I'll pull master into for-next in a few days so that we can do sparse
cleanup pass over the whole tree on the latest tree.

Thanks.

-- 
tejun
