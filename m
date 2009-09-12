Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbZILPaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbZILPaS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 11:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbZILPaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 11:30:17 -0400
Received: from fifo99.com ([67.223.236.141]:41544 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbZILPaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 11:30:16 -0400
Subject: Re: [PATCH 3/3] devmem: remove redundant parameter from
 do_write_kmem()
From: Daniel Walker <dwalker@fifo99.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>,
       Avi Kivity <avi@qumranet.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090912152259.384529634@intel.com>
References: <20090912152039.479536123@intel.com>
	 <20090912152259.384529634@intel.com>
Content-Type: text/plain
Date: Sat, 12 Sep 2009 08:30:54 -0700
Message-Id: <1252769454.28368.66.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-12 at 23:20 +0800, Wu Fengguang wrote:
>  static inline ssize_t
> -do_write_kmem(void *p, unsigned long realp, const char __user * buf,
> +do_write_kmem(unsigned long p, const char __user * buf,
>               size_t count, loff_t *ppos)
>  {

There's one style issue in the block above. Could you run your patches
through checkpatch and fix whatever errors it reports?

Daniel



