Return-Path: <linux-kernel-owner+w=401wt.eu-S932913AbXIGTcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913AbXIGTcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 15:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758158AbXIGTc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 15:32:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52173 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbXIGTc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 15:32:28 -0400
Date: Fri, 7 Sep 2007 20:31:59 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: Theodore Tso <tytso@mit.edu>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20070907193159.GA3023@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Valdis.Kletnieks@vt.edu, Theodore Tso <tytso@mit.edu>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org
References: <20070906200733.194442762@polymtl.ca> <20070906200825.893834634@polymtl.ca> <20070906160001.cfe48d78.randy.dunlap@oracle.com> <20070906160429.629c9497.akpm@linux-foundation.org> <20070906163737.9cc91307.randy.dunlap@oracle.com> <20070907160445.GB8911@thunk.org> <6791.1189185054@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6791.1189185054@turing-police.cc.vt.edu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2007 at 01:10:54PM -0400, Valdis.Kletnieks@vt.edu wrote:
> Anybody got a proposed scheme for the case where somebody like myself
> who is *not* a member of the Maintainer Cabal has looked at a patch, and
> found a valid show-stopper that's bigger than just whitespace (breaks on
> 64-bit, locking issues, etc), or other commentary that *should* be addressed
> before it gets merged?  I'd like *some* way to tag a patch with "I had an
> issue with V1, but the author addressed it to my satisfaction in V2"....
> 
> (Note that includes "the author convinced me the patch was right and I was
> wrong"...)

I think that'd be Reviewed-By.  While you are not part of the smokey room
cabal you have shown technical expertise in various areas so it seems
perfectly fine to have reviewed-by from you.  The fix vs a previous version
should probably be just in the text with a paragraph ala:

Issue blah in a previous version as found by Valdis Kletnieks has been fixed
by doing foo.
