Return-Path: <linux-kernel-owner+w=401wt.eu-S1759907AbZJOBdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759907AbZJOBdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 21:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755614AbZJOBdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 21:33:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:45364 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbZJOBdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 21:33:39 -0400
Message-ID: <4AD67C05.2030201@kernel.org>
Date: Thu, 15 Oct 2009 10:33:57 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Jes Sorensen <jes@sgi.com>,
       linux-ia64@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] ia64/sn: fix percpu warnings
References: <20091014163445.f0441473.sfr@canb.auug.org.au> <20091014151003.0ef42973.randy.dunlap@oracle.com>
In-Reply-To: <20091014151003.0ef42973.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 01:32:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix percpu types warning in ia64/sn:
> 
> arch/ia64/sn/kernel/setup.c:74: error: conflicting types for '__pcpu_scope___sn_cnodeid_to_nasid'
> arch/ia64/include/asm/sn/arch.h:74: error: previous declaration of '__pcpu_scope___sn_cnodeid_to_nasid' was here
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Jes Sorensen <jes@sgi.com>

Acked-by: Tejun Heo <tj@kernel.org>

Can this go through ia64 tree?  If not, I can route it through
percpu#for-fixes.

Thanks.

-- 
tejun
