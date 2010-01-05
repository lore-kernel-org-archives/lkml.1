Return-Path: <linux-kernel-owner+w=401wt.eu-S1754352Ab0AECor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab0AECor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 21:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040Ab0AECoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:44:46 -0500
Received: from mail.gmx.net ([213.165.64.20]:57087 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753463Ab0AECoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:44:46 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/pckR1dnzpJt19NZ63A6695RMoqqWCTzqJq06uyL
	KOax7BO92ILKG3
Subject: Re: volano ~30% regression with 2.6.33-rc1 & -rc2
From: Mike Galbraith <efault@gmx.de>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1262652299.22471.117.camel@minggr.sh.intel.com>
References: <1262592958.22471.104.camel@minggr.sh.intel.com>
	 <20100104044024.5390ff1c@infradead.org>
	 <1262652299.22471.117.camel@minggr.sh.intel.com>
Content-Type: text/plain
Date: Tue, 05 Jan 2010 03:44:43 +0100
Message-Id: <1262659483.5748.0.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-05 at 08:44 +0800, Lin Ming wrote:
> On Mon, 2010-01-04 at 20:40 +0800, Arjan van de Ven wrote:
> > On Mon, 04 Jan 2010 16:15:58 +0800
> > Lin Ming <ming.m.lin@intel.com> wrote:
> > 
> > > Mike & Peter,
> > > 
> > > Compared with 2.6.32, volano has ~30% regression with 2.6.33-rc1 &
> > > -rc2. Testing machine: Tigerton Xeon, 16cpus(4P/4Core), 16G memory
> > 
> > did this show up only on this cpu?
> > (since this is a multi-core-without-shared-cache cpu, it could be that
> > we get the topology wrong and think cores share cache where they don't)
> 
> Tulsa machine(16cpus, 4P/2Core/HT) also has ~8% regression
> and it's now fixed by Mike's patch.

Excellent.  Thanks for testing.

	-Mike

