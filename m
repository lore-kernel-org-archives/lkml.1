Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbXISInE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbXISInE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 04:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbXISImz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 04:42:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:58449 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754213AbXISImy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 04:42:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX194ctEN8Zt4liQ067q6jd0FXDQFBXQKeDrueFRHCT
	2UeQwAxzXtLKJf
Subject: Re: [git] CFS-devel, group scheduler, fixes
From: Mike Galbraith <efault@gmx.de>
To: Tong Li <tong.n.li@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, dimm <dmitry.adamushko@gmail.com>,
       linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1190188261.9185.21.camel@Homer.simpson.net>
References: <1190144190.5204.24.camel@earth> <20070918201622.GA1632@elte.hu>
	 <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com>
	 <1190183324.9737.7.camel@Homer.simpson.net>
	 <1190188261.9185.21.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 10:42:48 +0200
Message-Id: <1190191368.8687.5.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-19 at 09:51 +0200, Mike Galbraith wrote:

> The scenario which was previously cured was this:
> taskset -c 1 nice -n 0 ./massive_intr 2 9999
> taskset -c 1 nice -n 5 ./massive_intr 2 9999
> click link
> (http://pages.cs.wisc.edu/~shubu/talks/cachescrub-prdc2004.ppt) to bring
> up browser and OpenOffice Impress.
> 
> Xorg (at nice -5 + above scenario) latency samples:
> se.wait_max              :            57985337
> se.wait_max              :            25163510
> se.wait_max              :            37005538
> se.wait_max              :            66986511
> se.wait_max              :            53990868
> se.wait_max              :            80976761
> se.wait_max              :            96967501
> se.wait_max              :            80989254
> se.wait_max              :            53990897
> se.wait_max              :           181963905
> se.wait_max              :            85985181

To be doubly sure of the effect on the pinned tasks + migrating Xorg
scenario, I just ran the above test 10 times with virgin devel source.
Maximum Xorg latency was 20ms.

	-Mike

