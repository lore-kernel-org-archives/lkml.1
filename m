Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbYBRVpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbYBRVpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbYBRVpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:45:05 -0500
Received: from ns.suse.de ([195.135.220.2]:54051 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbYBRVpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:45:03 -0500
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 19 Feb 2008 08:45:03 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18361.64607.812442.423082@notabene.brown>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fs/drop_caches.c: make 2 functions static
In-Reply-To: message from Andrew Morton on Monday February 18
References: <20080217081746.GI3848@cs181133002.pp.htv.fi>
	<20080218050147.17f5ee0b.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday February 18, akpm@linux-foundation.org wrote:
> On Sun, 17 Feb 2008 10:17:46 +0200 Adrian Bunk <bunk@kernel.org> wrote:
> 
> > This patch makes the following needlessly global functions static:
> > - drop_pagecache()
> > - drop_slab()
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
..
> 
> This was originally done because Neil said that he planned to use these in
> nfsd.  I guess that didn't happen, and an additional patch would be needed
> here anyway to do the module exports.  So....  zap.

Did I?  I wonder why.  Neither my memory or my mail archive gives me
any hints, so I suspect it must have just been a passing fancy that
resolved into a really dumb idea (as so many passing fancies do).

Zap-supported-by: NeilBrown <neilb@suse.de>

Hmmm... I guess that should really be

  Acked-By: NeilBrown <neilb@suse.de>
;-)

NeilBrown
