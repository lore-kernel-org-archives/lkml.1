Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbYKUQMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbYKUQMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbYKUQMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:12:42 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:40092 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbYKUQMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:12:41 -0500
Date: Fri, 21 Nov 2008 10:11:49 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Ingo Molnar <mingo@elte.hu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [Bug #11308] tbench regression on each kernel release from 2.6.22
 -&gt; 2.6.28
In-Reply-To: <20081121083044.GL16242@elte.hu>
Message-ID: <Pine.LNX.4.64.0811210936580.25354@quilx.com>
References: <1ScKicKnTUE.A.VxH.DIHIJB@chimera> <NjF0-fuClJC.A.73B.cLHIJB@chimera>
 <20081117090648.GG28786@elte.hu> <Pine.LNX.4.64.0811191341570.23502@quilx.com>
 <Pine.LNX.4.64.0811201727070.9089@quilx.com> <20081121083044.GL16242@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008, Ingo Molnar wrote:

> > 2.6.22:
> > Throughput 2526.15 MB/sec 8 procs
> > 2.6.28-rc5:
> > Throughput 2486.2 MB/sec 8 procs
> >
> > 8p Dell 1950 and the number of processors specified on the tbench
> > command line.
>
> ... so might be worth a test. Just to satisfy our curiosity and to
> possibly close the entry :-)

Ahh.. Wow.... net-next gets us:

Throughput 2685.17 MB/sec 8 procs


