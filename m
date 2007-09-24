Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbXIXKm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbXIXKm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 06:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbXIXKmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 06:42:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:49254 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753359AbXIXKmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 06:42:20 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+HXIg2cYWHLPrPK+VqRVQo9e3szkM+aHwF4Y7V+2
	K+K3DQ6SWpWyoW
Subject: Re: [git] CFS-devel, group scheduler, fixes
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tong Li <tong.n.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
       dimm <dmitry.adamushko@gmail.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <20070924122422.75562c41@twins>
References: <1190144190.5204.24.camel@earth> <20070918201622.GA1632@elte.hu>
	 <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com>
	 <1190183324.9737.7.camel@Homer.simpson.net>
	 <1190188261.9185.21.camel@Homer.simpson.net>
	 <1190191368.8687.5.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0709190944560.11561@tongli.jf.intel.com>
	 <1190264114.6411.4.camel@Homer.simpson.net>
	 <1190272507.27867.20.camel@Homer.simpson.net>
	 <20070920075155.GA31641@elte.hu>
	 <1190275870.9232.6.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0709212018480.16240@tongli.jf.intel.com>
	 <1190455308.7404.19.camel@Homer.simpson.net>
	 <1190531662.11524.15.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0709232259150.23861@tongli.jf.intel.com>
	 <1190628609.6389.14.camel@Homer.simpson.net>
	 <20070924122422.75562c41@twins>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 12:42:15 +0200
Message-Id: <1190630535.7406.2.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 12:24 +0200, Peter Zijlstra wrote:

> how about something like:
> 
>  s64 delta = (s64)(vruntime - min_vruntime);
>  if (delta > 0)
>   min_vruntime += delta;
> 
> That would rid us of most of the funny conditionals there.

That still left me with negative min_vruntimes.  The pinned hogs didn't
lock my box up, but I quickly got the below, so hastily killed it.

se.wait_max              :             7.846949
se.wait_max              :           301.951601
se.wait_max              :             7.071359

	-Mike

