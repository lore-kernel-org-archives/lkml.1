Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbXLRLJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbXLRLJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 06:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbXLRLJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 06:09:05 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:50893 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbXLRLJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 06:09:04 -0500
Date: Tue, 18 Dec 2007 14:08:47 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: David Chinner <dgc@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [0/4] DST: Distributed storage.
Message-ID: <20071218110847.GB4193@2ka.mipt.ru>
References: <20071214133747.GC31971@2ka.mipt.ru> <11979038181687@2ka.mipt.ru> <20071218010003.GE4396912@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218010003.GE4396912@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David.

On Tue, Dec 18, 2007 at 12:00:04PM +1100, David Chinner (dgc@sgi.com) wrote:
> On Mon, Dec 17, 2007 at 06:03:38PM +0300, Evgeniy Polyakov wrote:
> > DST passed all FS tests in LTP with XFS (modulo MAX_LOCK_DEPTH too low bug:
> > [ 8398.605691] BUG: MAX_LOCK_DEPTH too low!
> > [ 8398.609641] turning off the locking correctness validator.
> 
> Evgeniy, can you please start reporting these XFS problems you are
> coming across to the XFS list (xfs@oss.sgi.com)? They may be
> real issues that we need to address and we should not be hearing
> about them for the first time in the release notes for a block
> device project....

It is not XFS as is, but lock validator warning. I just found it
working with XFS - it can be anything else: VFS, block layer, DST itself
(there is number of locks too), so I did not fill the bug against
filesystem, but pointed that some problem, probalby harmless,
exists in tested environment.

-- 
	Evgeniy Polyakov
