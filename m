Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbYAVV4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbYAVV4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 16:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbYAVV4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 16:56:05 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:51223 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbYAVV4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 16:56:04 -0500
X-IronPort-AV: E=Sophos;i="4.25,235,1199692800"; 
   d="scan'208";a="3773112"
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: InfiniBand/RDMA merge plans for 2.6.25
X-Message-Flag: Warning: May contain useful information
References: <ada7ii8xaao.fsf@cisco.com> <20080121100151.GD5333@infradead.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 22 Jan 2008 13:56:00 -0800
In-Reply-To: <20080121100151.GD5333@infradead.org> (Christoph Hellwig's message of "Mon, 21 Jan 2008 10:01:51 +0000")
Message-ID: <adad4rttthr.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 Jan 2008 21:56:01.0189 (UTC) FILETIME=[93ACC550:01C85D41]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > >  - Neteffect "nes" driver.  It's not terribly clean code but since
 > >    it's a new driver that is completely self-contained, I plan on
 > >    merging it and letting cleanups happen upstream.
 > 
 > New code should be better quality than old code, not worse.   I haven't
 > actually seen the driver yet, but by that statement I'd be clearly
 > against a merge.

The driver has been posted a few times; the latest code is in the
"neteffect" branch of my tree:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git neteffect

It's not *that* bad -- certainly there are lots of things that could
be improved (sparse endianness annotation, too many lines that are way
to long, strange indentation of case labeles, etc, etc) but it is a
self-contained hardware driver.  I agree with Linus's position (stated
at the last kernel summit) that we ought to merge hardware drivers
early, so that users get the drivers with as little hassle as
possible.  We lose a little leverage in getting cleanups done, but the
number of people who see the code and are able to clean it up
increases, so I think it's a good trade-off.

 - R.
