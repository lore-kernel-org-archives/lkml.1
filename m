Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333Ab0ADM5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab0ADM5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 07:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184Ab0ADM5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 07:57:39 -0500
Received: from mail.gmx.net ([213.165.64.20]:37458 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753172Ab0ADM5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 07:57:38 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+S7FA1VFWS8Fl1w5vjdTJPyjAhBA6fEQ0zPTFWVq
	g7gFLUGA4j8SlW
Subject: Re: volano ~30% regression with 2.6.33-rc1 & -rc2
From: Mike Galbraith <efault@gmx.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <20100104044024.5390ff1c@infradead.org>
References: <1262592958.22471.104.camel@minggr.sh.intel.com>
	 <20100104044024.5390ff1c@infradead.org>
Content-Type: text/plain
Date: Mon, 04 Jan 2010 13:57:34 +0100
Message-Id: <1262609854.9734.56.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 04:40 -0800, Arjan van de Ven wrote:
> On Mon, 04 Jan 2010 16:15:58 +0800
> Lin Ming <ming.m.lin@intel.com> wrote:
> 
> > Mike & Peter,
> > 
> > Compared with 2.6.32, volano has ~30% regression with 2.6.33-rc1 &
> > -rc2. Testing machine: Tigerton Xeon, 16cpus(4P/4Core), 16G memory
> 
> did this show up only on this cpu?
> (since this is a multi-core-without-shared-cache cpu, it could be that
> we get the topology wrong and think cores share cache where they don't)

My fault for using PREFER_SIBLING I guess.  However, I do wonder why in
the heck we set that at the CPU domain level.  Siblings lie northward.

	-Mike

