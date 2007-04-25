Return-Path: <linux-kernel-owner+w=401wt.eu-S2992562AbXDYKZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992562AbXDYKZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992571AbXDYKZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:25:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992562AbXDYKZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:25:42 -0400
From: Neil Brown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Wed, 25 Apr 2007 20:25:26 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17967.11414.227668.186113@notabene.brown>
Cc: Brad Campbell <brad@wasp.net.au>, Chuck Ebbert <cebbert@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
In-Reply-To: message from Jens Axboe on Wednesday April 25
References: <17956.22235.574867.179016@notabene.brown>
	<20070418123757.GC3796@kernel.dk>
	<46261ACE.1050407@wasp.net.au>
	<20070418132157.GC3720@kernel.dk>
	<462B10C3.1030906@wasp.net.au>
	<20070423073543.GE5311@kernel.dk>
	<462E5D38.5000801@wasp.net.au>
	<17967.4734.783140.512857@notabene.brown>
	<20070425084607.GM9715@kernel.dk>
	<17967.8536.788076.851546@notabene.brown>
	<20070425094712.GP9715@kernel.dk>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday April 25, jens.axboe@oracle.com wrote:
> 
> Here's a fix for it, confirmed.
> 

Patch looks good to me.
Hopefully Brad can still wait for the WARN_ON to fire - it might give
useful clues to why this is happening.  It might be interesting.

Thanks,
NeilBrown
