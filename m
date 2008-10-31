Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbYJaJY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbYJaJY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 05:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYJaJYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 05:24:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35430 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbYJaJYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 05:24:19 -0400
Date: Fri, 31 Oct 2008 10:23:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Simon Horman <horms@verge.net.au>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org
Subject: Re: [PATCH 0/3 -v4] kexec/i386: kexec page table code clean up
Message-ID: <20081031092341.GD14127@elte.hu>
References: <1225417677.24095.135.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225417677.24095.135.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang Ying <ying.huang@intel.com> wrote:

> This patchset cleans up page table setup code of kexec on i386.
> 
> This patchset is based on v2.6.28-rc2-338-g65fc716 and has been 
> tested on i386.

applied to tip/x86/crashdump:

 9868ee6: kexec/i386: setup kexec page table in C
 92be3d6: kexec/i386: allocate page table pages dynamically
 31498a0: kexec/i386: remove PAGE_SIZE alignment from relocate_kernel

thanks! They are nice cleanups - both the .text reduction and the 
linecount reduction is nice:

 4 files changed, 102 insertions(+), 152 deletions(-)

	Ingo
