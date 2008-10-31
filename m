Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbYJaB4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbYJaB4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 21:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYJaB42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 21:56:28 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:43712 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbYJaB42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 21:56:28 -0400
Date: Fri, 31 Oct 2008 12:56:25 +1100
From: Simon Horman <horms@verge.net.au>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org
Subject: Re: [PATCH -mm 0/3 -v3] kexec/i386: kexec page table code clean up
Message-ID: <20081031015623.GA27118@verge.net.au>
References: <1225354615.24095.110.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225354615.24095.110.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 04:16:55PM +0800, Huang Ying wrote:
> This patchset cleans up page table setup code of kexec on i386.
> 
> This patchset is based on 2.6.28-rc2-mm1 and has been tested on i386.
> 
> v3:
> 
> - Remove PAGE_SIZE alignment from relocate_kernel()
> 
> - Re-based on 2.6.28-rc2-mm1
> 
> v2:
> 
> - Rename some function names, such as alloc_page_tables ->
>   machine_kexec_alloc_page_tables, etc.
> 
> - Cleanup error processing for machine_alloc_page_tables.

These changes seem reasonable to me.

Reviewd-by: Simon Horman <horms@verge.net.au>

-- 
Simon Horman
  VA Linux Systems Japan K.K., Sydney, Australia Satellite Office
  H: www.vergenet.net/~horms/             W: www.valinux.co.jp/en

