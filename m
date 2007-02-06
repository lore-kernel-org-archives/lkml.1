Return-Path: <linux-kernel-owner+w=401wt.eu-S1752016AbXBFJsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbXBFJsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXBFJsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:48:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40547 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbXBFJsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:48:09 -0500
Date: Tue, 6 Feb 2007 09:48:07 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andreas Gruenbacher <agruen@suse.de>,
       Christoph Hellwig <hch@infradead.org>, Tony Jones <tonyj@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, linux-security-module@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
Message-ID: <20070206094807.GC5328@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Andreas Gruenbacher <agruen@suse.de>, Tony Jones <tonyj@suse.de>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chrisw@sous-sol.org, linux-security-module@vger.kernel.org,
	viro@zeniv.linux.org.uk
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com> <1170701906.5934.41.camel@lade.trondhjem.org> <20070205190230.GA23104@infradead.org> <200702051920.36057.agruen@suse.de> <1170751912.6242.30.camel@lade.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170751912.6242.30.camel@lade.trondhjem.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 12:51:52AM -0800, Trond Myklebust wrote:
> Who cares? There is no way to export a partial directory, and in any
> case the subtree_check crap is borken beyond repair (see cross-directory
> renames which lead to actual changes to the filehandle - broken, broken,
> broken!!!!).

It's getting a little oftopic for this thread, but is there a chance we
could just kill that crap after a resonable deprecation period?

