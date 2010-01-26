Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502Ab0AZCnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab0AZCnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 21:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122Ab0AZCnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 21:43:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:40709 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab0AZCnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 21:43:06 -0500
Message-ID: <4B5E57D2.8030109@kernel.org>
Date: Tue, 26 Jan 2010 11:47:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, ebiederm@xmission.com, tytso@mit.edu,
       Trond.Myklebust@netapp.com, aelder@sgi.com, hch@infradead.org,
       viro@zeniv.linux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
       x86@kernel.org, mingo@redhat.com, dan.j.williams@intel.com,
       borislav.petkov@amd.com, ying.huang@intel.com, lenb@kernel.org,
       neilb@suse.de, cl@linux-foundation.org
Subject: Re: [PATCH 7/8] percpu: add __percpu sparse annotations to	hw_breakpoint
References: <1264432935-10453-8-git-send-email-tj@kernel.org> <20100126001901.GI5087@nowhere> <4B5E3BED.6030705@kernel.org> <20100126010239.GK5087@nowhere> <4B5E4308.8020105@kernel.org> <20100126020113.GM5087@nowhere> <4B5E4FE7.30700@kernel.org> <20100126021846.GO5087@nowhere> <20100126022211.GP5087@nowhere> <4B5E54C0.2040709@kernel.org> <20100126023542.GQ5087@nowhere>
In-Reply-To: <20100126023542.GQ5087@nowhere>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Jan 2010 02:41:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2010 11:35 AM, Frederic Weisbecker wrote:
> No guarantee that will build. I should pull your tree and install
> sparse (yeah, shame on me, I've never installed it).

Nope, it doesn't.  Please pull from the following tree to receive the
whole thing.  The definitions in question are in
include/asm-generic/percpu.h.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git percpu-sparse-review

After installing sparse,

 make C=2 arch/x86/kernel/cpu/common.o

should be enough.

Thanks.

-- 
tejun
