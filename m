Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbXIUClQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbXIUClQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 22:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbXIUClA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 22:41:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:33111 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753131AbXIUCk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 22:40:59 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX193UkBQLGd39kFXKxe5Iea0dRxMOOQkNLaRqkHziW
	5ks7/XF5cUfQ9C
Subject: Re: [git] CFS-devel, group scheduler, fixes
From: Mike Galbraith <efault@gmx.de>
To: Willy Tarreau <w@1wt.eu>
Cc: Tong Li <tong.n.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
       dimm <dmitry.adamushko@gmail.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20070920194813.GH10199@1wt.eu>
References: <1190144190.5204.24.camel@earth> <20070918201622.GA1632@elte.hu>
	 <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com>
	 <1190183324.9737.7.camel@Homer.simpson.net>
	 <1190188261.9185.21.camel@Homer.simpson.net>
	 <1190191368.8687.5.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0709190944560.11561@tongli.jf.intel.com>
	 <1190264114.6411.4.camel@Homer.simpson.net>
	 <1190272507.27867.20.camel@Homer.simpson.net>
	 <20070920194813.GH10199@1wt.eu>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 04:40:55 +0200
Message-Id: <1190342455.6461.6.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 21:48 +0200, Willy Tarreau wrote:

> I don't know if this is relevant, but 4294966399 in nr_uninterruptible
> for cpu#0 equals -897, exactly the negation of cpu1.nr_uninterruptible.
> I don't know if this rings a bell for someone or if it's a completely
> useless comment, but just in case...

A task can block on one cpu, and wake up on another, which isn't
tracked, hence the fishy looking numbers.  The true nr_uninterruptible
is the sum of all.

	-Mike

