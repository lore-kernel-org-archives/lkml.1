Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbXIGVas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbXIGVas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 17:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758575AbXIGVal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 17:30:41 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:35986 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758574AbXIGVaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 17:30:39 -0400
X-IronPort-AV: E=Sophos;i="4.20,222,1186383600"; 
   d="scan'208";a="214206459"
To: Christoph Hellwig <hch@infradead.org>
Cc: Valdis.Kletnieks@vt.edu, Theodore Tso <tytso@mit.edu>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] Linux Kernel Markers - Architecture Independent Code
X-Message-Flag: Warning: May contain useful information
References: <20070906200733.194442762@polymtl.ca>
	<20070906200825.893834634@polymtl.ca>
	<20070906160001.cfe48d78.randy.dunlap@oracle.com>
	<20070906160429.629c9497.akpm@linux-foundation.org>
	<20070906163737.9cc91307.randy.dunlap@oracle.com>
	<20070907160445.GB8911@thunk.org>
	<6791.1189185054@turing-police.cc.vt.edu>
	<20070907193159.GA3023@infradead.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 07 Sep 2007 14:30:36 -0700
In-Reply-To: <20070907193159.GA3023@infradead.org> (Christoph Hellwig's message of "Fri, 7 Sep 2007 20:31:59 +0100")
Message-ID: <adalkbirwn7.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Sep 2007 21:30:36.0628 (UTC) FILETIME=[545F7940:01C7F196]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Anybody got a proposed scheme for the case where somebody like myself
 > > who is *not* a member of the Maintainer Cabal has looked at a patch, and
 > > found a valid show-stopper that's bigger than just whitespace (breaks on
 > > 64-bit, locking issues, etc), or other commentary that *should* be addressed
 > > before it gets merged?  I'd like *some* way to tag a patch with "I had an
 > > issue with V1, but the author addressed it to my satisfaction in V2"....

 > I think that'd be Reviewed-By.  While you are not part of the smokey room
 > cabal you have shown technical expertise in various areas so it seems
 > perfectly fine to have reviewed-by from you.  The fix vs a previous version
 > should probably be just in the text with a paragraph ala:

 > Issue blah in a previous version as found by Valdis Kletnieks has been fixed
 > by doing foo.

At ksummit Andrew also mentioned including a link to the relevant
mailing list discussion too, and I think this would be a good example
of when that would be useful.

 - R.
