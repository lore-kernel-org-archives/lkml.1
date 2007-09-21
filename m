Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbXIUDNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbXIUDNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 23:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbXIUDMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 23:12:55 -0400
Received: from 1wt.eu ([62.212.114.60]:2599 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538AbXIUDMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 23:12:54 -0400
Date: Fri, 21 Sep 2007 05:11:39 +0200
From: Willy Tarreau <w@1wt.eu>
To: Mike Galbraith <efault@gmx.de>
Cc: Tong Li <tong.n.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
       dimm <dmitry.adamushko@gmail.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git] CFS-devel, group scheduler, fixes
Message-ID: <20070921031139.GA19584@1wt.eu>
References: <20070918201622.GA1632@elte.hu> <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com> <1190183324.9737.7.camel@Homer.simpson.net> <1190188261.9185.21.camel@Homer.simpson.net> <1190191368.8687.5.camel@Homer.simpson.net> <Pine.LNX.4.64.0709190944560.11561@tongli.jf.intel.com> <1190264114.6411.4.camel@Homer.simpson.net> <1190272507.27867.20.camel@Homer.simpson.net> <20070920194813.GH10199@1wt.eu> <1190342455.6461.6.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190342455.6461.6.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 04:40:55AM +0200, Mike Galbraith wrote:
> On Thu, 2007-09-20 at 21:48 +0200, Willy Tarreau wrote:
> 
> > I don't know if this is relevant, but 4294966399 in nr_uninterruptible
> > for cpu#0 equals -897, exactly the negation of cpu1.nr_uninterruptible.
> > I don't know if this rings a bell for someone or if it's a completely
> > useless comment, but just in case...
> 
> A task can block on one cpu, and wake up on another, which isn't
> tracked, hence the fishy looking numbers.  The true nr_uninterruptible
> is the sum of all.

OK, thanks Mike for this clarification.

Willy

