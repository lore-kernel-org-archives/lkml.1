Return-Path: <linux-kernel-owner+w=401wt.eu-S1760985AbYDKQ1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760985AbYDKQ1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 12:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760209AbYDKQ11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 12:27:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46066 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760156AbYDKQ10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 12:27:26 -0400
Subject: Re: [PATCH 00/13] Re: Scalability requirements for sysv ipc
From: Peter Zijlstra <peterz@infradead.org>
To: Nadia.Derbey@bull.net
Cc: efault@gmx.de, manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org, xemul@openvz.org
In-Reply-To: <20080411161702.460410000@bull.net>
References: <20080411161702.460410000@bull.net>
Content-Type: text/plain
Date: Fri, 11 Apr 2008 18:27:15 +0200
Message-Id: <1207931235.7157.0.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-11 at 18:17 +0200, Nadia.Derbey@bull.net wrote:
> 
> Here is finally the ipc ridr-based implementation I was talking about last
> week (see http://lkml.org/lkml/2008/4/4/208).
> I couldn't avoid much of the code duplication, but at least made things
> incremental.
> 
> Does somebody now a test suite that exists for the idr API, that I could
> run on this new api?
> 
> Mike, can you try to run it on your victim: I had such a hard time building
> this patch, that I couldn't re-run the test on my 8-core with this new
> version. So the last results I have are for 2.6.25-rc3-mm1.
> 
> Also, I think a careful review should be done to avoid introducing yet other
> problems :-(

Why duplicate the whole thing, when we converted the Radix tree to be
RCU safe we did it in-place. Is there a reason this is not done for idr?

