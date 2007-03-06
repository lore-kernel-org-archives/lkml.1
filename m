Return-Path: <linux-kernel-owner+w=401wt.eu-S933373AbXCFADU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373AbXCFADU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 19:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933372AbXCFADU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 19:03:20 -0500
Received: from cantor.suse.de ([195.135.220.2]:40500 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933344AbXCFADT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 19:03:19 -0500
From: Neil Brown <neilb@suse.de>
To: Bill Davidsen <davidsen@tmr.com>
Date: Tue, 6 Mar 2007 11:01:53 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17900.44913.481329.963558@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: Fix for raid6 reshape.
In-Reply-To: message from Bill Davidsen on Friday March 2
References: <20070302155626.19014.patches@notabene>
	<1070302045655.19069@suse.de>
	<20070301223619.d9957521.akpm@linux-foundation.org>
	<17895.50900.585915.565155@notabene.brown>
	<45E88A50.8060906@tmr.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday March 2, davidsen@tmr.com wrote:
> >   
> >>> +	conf->expand_progress = (sector_nr + i) * new_data_disks;
> >>>       
> Will the (real) fix be in 2.6.21?

It is now in Linus' git tree, so yes.

NeilBrown
