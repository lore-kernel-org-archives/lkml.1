Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbYABT0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbYABT0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbYABT03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:26:29 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:35767 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbYABT02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:26:28 -0500
Date: Wed, 2 Jan 2008 20:26:30 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>, mshefty@ichips.intel.com,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, hal.rosenstock@gmail.com
Subject: Re: (Try #2) [Patch 5/8] INFINIBAND: Remove 'TOPDIR' from Makefiles
Message-ID: <20080102192630.GD11217@uranus.ravnborg.org>
References: <20080101071311.GA2496@hacking> <20080101073331.GF2496@hacking> <20080101102637.GE28913@uranus.ravnborg.org> <20080101134108.GE2499@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101134108.GE2499@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 09:41:08PM +0800, WANG Cong wrote:
> 
> >> -EXTRA_CFLAGS += -I$(TOPDIR)/drivers/net/cxgb3 \
> >> -		-I$(TOPDIR)/drivers/infiniband/hw/cxgb3/core
> >
> >> +EXTRA_CFLAGS += -I$(objtree)/drivers/net/cxgb3 \
> >Drop $(TOPDIR) like this:
> >> +EXTRA_CFLAGS += -Idrivers/net/cxgb3 \
> >
> >> +		-I$(objtree)/drivers/infiniband/hw/cxgb3/core
> >And this line can be deleted - there is no such directory.
> >At least not in my tree.
> 
> Yes, correct. Thank you.
> 
> ----------->
> 
> This patch removes TOPDIR from infiniband Makefiles.
> 
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Roland Dreier <rolandd@cisco.com>
> Cc: Sean Hefty <mshefty@ichips.intel.com>
> Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

Applied.

	Sam
