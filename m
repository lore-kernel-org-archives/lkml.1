Return-Path: <linux-kernel-owner+w=401wt.eu-S1764112AbXGWHK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764112AbXGWHK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 03:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756050AbXGWHKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 03:10:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:55808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402AbXGWHKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 03:10:13 -0400
From: Neil Brown <neilb@suse.de>
To: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 Jul 2007 17:10:02 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18084.21578.171810.48265@notabene.brown>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: [GIT PATCH 0/2] stripe-queue for 2.6.23 consideration
In-Reply-To: message from Dan Williams on Sunday July 22
References: <20070722094115.18906.64495.stgit@dwillia2-linux.ch.intel.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday July 22, dan.j.williams@intel.com wrote:
> Andrew, Neil,
> 
> The stripe-queue patches are showing solid performance improvement.
> 
> 	git://lost.foo-projects.org/~dwillia2/git/iop md-for-linus
> 
>  drivers/md/raid5.c         | 1484 ++++++++++++++++++++++++++++++++------------
>  include/linux/raid/raid5.h |   87 +++-
>  2 files changed, 1164 insertions(+), 407 deletions(-)
> 
> Dan Williams (2):
>       raid5: add the stripe_queue object for tracking raid io requests (take2)
>       raid5: use stripe_queues to prioritize the "most deserving" requests (take4)
> 
> I initially considered them 2.6.24 material but after fixing the sync+io
> data corruption regression, fixing the large 'stripe_cache_size' values
> performance regression, and seeing how well it performed on my IA
> platform I would like them to be considered for 2.6.23.  That being said
> I have not yet tested expand operations or raid6.
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I think we really shouldn't aim for 2.6.23 at this stage.  The merge
window is shut, and this is a little more that a bug fix.  It's sounds
great though.  I'd really like to hear more success reports, and will
do my own review a testing either this week or next.

Certainly good for -mm.

NeilBrown
