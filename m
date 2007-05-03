Return-Path: <linux-kernel-owner+w=401wt.eu-S376287AbXECSom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376287AbXECSom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 14:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376296AbXECSom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 14:44:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:48555 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S376287AbXECSol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 14:44:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,487,1170662400"; 
   d="scan'208";a="223848055"
Subject: Re: [patch] CFS scheduler, -v8
From: "Li, Tong N" <tong.n.li@intel.com>
To: William Lee Irwin III <wli@holomorphy.com>
CC: Srivatsa Vaddagiri <vatsa@in.ibm.com>, Damien Wyart <damien.wyart@free.fr>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
In-Reply-To: <20070503155347.GF19966@holomorphy.com>
References: <46399B51.9040608@dunaweb.hu> <20070503130201.GA9000@elte.hu>
	 <20070503132932.GA4204@localhost.localdomain>
	 <20070503145318.GA17776@in.ibm.com> <20070503155347.GF19966@holomorphy.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 3 May 2007 11:44:27 -0700
Message-ID: <1178217867.7475.23.camel@tongli.jf.intel.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 03 May 2007 18:44:27.0781 (UTC) FILETIME=[1403E350:01C78DB3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 08:53 -0700, William Lee Irwin III wrote:
> On Thu, May 03, 2007 at 03:29:32PM +0200, Damien Wyart wrote:
> >> What are your thoughts/plans concerning merging CFS into mainline ? Is
> >> it a bit premature to get it into 2.6.22 ? I remember Linus was ok to
> >> change the default scheduler rapidly (the discussion was about sd at
> >> that time) to get more testing than in -mm.
> 
> On Thu, May 03, 2007 at 08:23:18PM +0530, Srivatsa Vaddagiri wrote:
> > And what about group scheduling extensions? Do you have plans to work on
> > it? I was begining to work on a prototype to do group scheduling based
> > on CFS, basically on the lines of what you and Linus had outlined
> > earlier:
> > 	http://lkml.org/lkml/2007/4/18/271
> > 	http://lkml.org/lkml/2007/4/18/244
> 
> Tong Li's Trio scheduler does a bit of this, though it doesn't seem to
> have the mindshare cfs seems to have acquired.
> 
> The hyperlink seems to have broken, though:
> 	http://www.cs.duke.edu/~tongli/linux/linux-2.6.19.2-trio.patch

Yeah, I just fixed the link. The code was written based on the 2.6.19.2
scheduler. I could forward-port it to the latest kernel if there's
interest and I can find time. :) Here's a description of the design:

http://lkml.org/lkml/2007/4/20/286

Thanks,

  tong
