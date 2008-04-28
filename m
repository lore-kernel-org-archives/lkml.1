Return-Path: <linux-kernel-owner+w=401wt.eu-S933579AbYD1Kch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579AbYD1Kch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 06:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765483AbYD1KcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 06:32:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59772 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765388AbYD1KcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 06:32:08 -0400
Message-ID: <4815A7A5.9040507@firstfloor.org>
Date: Mon, 28 Apr 2008 12:32:05 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: nscott@aconex.com
CC: Christoph Hellwig <hch@infradead.org>,
       Denys Vlasenko <vda.linux@googlemail.com>, David Chinner <dgc@sgi.com>,
       xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
References: <200804261651.02078.vda.linux__2040.04651536724$1209223026$gmane$org@googlemail.com>	 <87iqy4wfjq.fsf@basil.nowhere.org> <20080426200701.GA10883@infradead.org>	 <20080426202630.GG17905@one.firstfloor.org>	 <20080426202323.GA14245@infradead.org> <1209341212.23166.122.camel@edge.scott.net.au>
In-Reply-To: <1209341212.23166.122.camel@edge.scott.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Having to compile chunks of XFS code in both kernel and
> userspace is also wierd (relative to other drivers),

Perhaps it would be a good idea to mark the files where that is expected
to work clearly.

> and
> its a side-effect of needing to do that (all the code
> dealing with specifics of ondisk format is shared).

But does that really need "STATIC"? Seems doubtful to me.

-Andi

