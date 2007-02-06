Return-Path: <linux-kernel-owner+w=401wt.eu-S1751747AbXBFKcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbXBFKcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 05:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbXBFKcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 05:32:22 -0500
Received: from cantor.suse.de ([195.135.220.2]:36312 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbXBFKcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 05:32:21 -0500
From: Neil Brown <neilb@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Date: Tue, 6 Feb 2007 21:31:46 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17864.22802.571551.987434@notabene.brown>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andreas Gruenbacher <agruen@suse.de>, Tony Jones <tonyj@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, linux-security-module@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
In-Reply-To: message from Christoph Hellwig on Tuesday February 6
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
	<1170701906.5934.41.camel@lade.trondhjem.org>
	<20070205190230.GA23104@infradead.org>
	<200702051920.36057.agruen@suse.de>
	<1170751912.6242.30.camel@lade.trondhjem.org>
	<20070206094807.GC5328@infradead.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday February 6, hch@infradead.org wrote:
> On Tue, Feb 06, 2007 at 12:51:52AM -0800, Trond Myklebust wrote:
> > Who cares? There is no way to export a partial directory, and in any
> > case the subtree_check crap is borken beyond repair (see cross-directory
> > renames which lead to actual changes to the filehandle - broken, broken,
> > broken!!!!).
> 
> It's getting a little oftopic for this thread, but is there a chance we
> could just kill that crap after a resonable deprecation period?

Probably.  A couple of years?
nfs-utils 1.1.0 is due to stop subtree_check from being the default.
After that is released, the next kernel can start printing warnings
that it might stop working in a couple of years.

NeilBrown
