Return-Path: <linux-kernel-owner+w=401wt.eu-S1422973AbXCBGl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422973AbXCBGl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 01:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422972AbXCBGl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 01:41:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:48291 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422897AbXCBGl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 01:41:27 -0500
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 2 Mar 2007 17:40:20 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17895.50900.585915.565155@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: Fix for raid6 reshape.
In-Reply-To: message from Andrew Morton on Thursday March 1
References: <20070302155626.19014.patches@notabene>
	<1070302045655.19069@suse.de>
	<20070301223619.d9957521.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday March 1, akpm@linux-foundation.org wrote:
> On Fri, 2 Mar 2007 15:56:55 +1100 NeilBrown <neilb@suse.de> wrote:
> 
> > -	conf->expand_progress = (sector_nr + i)*(conf->raid_disks-1);
> > +	conf->expand_progress = (sector_nr + i) * new_data_disks);
> 
> ahem.


It wasn't like that when I tested it, honest...
But the original got caught up with some other changes which were not
really related so I removed them all and just made this change
manually.... and totally messed it up (again).  Sorry.

Of course it should be

> > +	conf->expand_progress = (sector_nr + i) * new_data_disks;

NeilBrown
