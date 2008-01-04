Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbYADAmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbYADAmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 19:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbYADAmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 19:42:08 -0500
Received: from mail.suse.de ([195.135.220.2]:59267 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbYADAmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 19:42:06 -0500
From: Neil Brown <neilb@suse.de>
To: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 4 Jan 2008 11:41:55 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18301.32979.409077.527576@notabene.brown>
Cc: NeilBrown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] md: Fix data corruption when a degraded raid5 array is
	reshaped.
In-Reply-To: message from Dan Williams on Thursday January 3
References: <20080104094516.19216.patches@notabene>
	<1080103224636.19290@suse.de>
	<1199401234.9102.3.camel@dwillia2-linux.ch.intel.com>
	<1199403652.9102.30.camel@dwillia2-linux.ch.intel.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday January 3, dan.j.williams@intel.com wrote:
> 
> On closer look the safer test is:
> 
> 	!test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending).
> 
> The 'req_compute' field only indicates that a 'compute_block' operation
> was requested during this pass through handle_stripe so that we can
> issue a linked chain of asynchronous operations.
> 
> ---
> 
> From: Neil Brown <neilb@suse.de>

Technically that should probably be
  From: Dan Williams <dan.j.williams@intel.com>

now, and then I add
  Acked-by: NeilBrown <neilb@suse.de>

because I completely agree with your improvement.

We should keep an eye out for then Andrew commits this and make sure
the right patch goes in...

Thanks,
NeilBrown

