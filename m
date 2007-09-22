Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbXIVAK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbXIVAK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 20:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbXIVAKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 20:10:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:45355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbXIVAKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 20:10:13 -0400
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 22 Sep 2007 10:10:06 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18164.23902.732535.384492@notabene.brown>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, yur@emcraft.com, saeed.bishara@gmail.com,
       shannon.nelson@intel.com
Subject: Re: [PATCH 2.6.23-rc7 0/3] async_tx and md-accel fixes for 2.6.23
In-Reply-To: message from Andrew Morton on Friday September 21
References: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com>
	<20070921114823.49d00263.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday September 21, akpm@linux-foundation.org wrote:
> On Thu, 20 Sep 2007 18:27:35 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > Fix a couple bugs and provide documentation for the async_tx api.
> > 
> > Neil, please 'ack' patch #3.
> > 
> > git://lost.foo-projects.org/~dwillia2/git/iop async-tx-fixes-for-linus
> 
> Well it looks like Neil is on vacation or is hiding from us or something.

Neil is just not coping well with jet-lag....

Patch #3 looks good and necessary
  Acked-By: NeilBrown <neilb@suse.de>

I know that should probably be a "reviewed-by"....  I was a bit
surprised that the "handle_completed_read_requests" call was so early
in handle_stripe5 - I don't think the code was originally that early.
But it is probably right.   Hopefully my brain will have cleared by
Monday and I'll review it again then.

NeilBrown
