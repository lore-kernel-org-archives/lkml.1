Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041Ab0AEBAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab0AEBAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 20:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820Ab0AEBAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 20:00:41 -0500
Received: from mga14.intel.com ([143.182.124.37]:1881 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab0AEBAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 20:00:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="229172791"
Subject: Re: volano ~30% regression with 2.6.33-rc1 & -rc2
From: Lin Ming <ming.m.lin@intel.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <20100104044024.5390ff1c@infradead.org>
References: <1262592958.22471.104.camel@minggr.sh.intel.com>
	 <20100104044024.5390ff1c@infradead.org>
Content-Type: text/plain
Date: Tue, 05 Jan 2010 08:44:59 +0800
Message-Id: <1262652299.22471.117.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 20:40 +0800, Arjan van de Ven wrote:
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

Tulsa machine(16cpus, 4P/2Core/HT) also has ~8% regression
and it's now fixed by Mike's patch.

Lin Ming

