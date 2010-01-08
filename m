Return-Path: <linux-kernel-owner+w=401wt.eu-S1752384Ab0AHDef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab0AHDef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 22:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926Ab0AHDee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 22:34:34 -0500
Received: from mail.gmx.net ([213.165.64.20]:45634 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751406Ab0AHDee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 22:34:34 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Zy+pxkutZL+AypttDI4Zdvb5fmDV82+V0U8ldvm
	9bUhfazYb5/uyj
Subject: Re: [RFC PATCH] sched: Pass affine target cpu into wake_affine
From: Mike Galbraith <efault@gmx.de>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1262918331.3598.14.camel@minggr.sh.intel.com>
References: <1262595827.22471.108.camel@minggr.sh.intel.com>
	 <1262659686.22471.121.camel@minggr.sh.intel.com>
	 <1262663058.5748.32.camel@marge.simson.net>
	 <1262673817.9534.37.camel@marge.simson.net>
	 <1262853903.18931.17.camel@minggr.sh.intel.com>
	 <1262870055.9337.34.camel@marge.simson.net>
	 <1262918331.3598.14.camel@minggr.sh.intel.com>
Content-Type: text/plain
Date: Fri, 08 Jan 2010 04:34:29 +0100
Message-Id: <1262921669.5601.25.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-08 at 10:38 +0800, Lin Ming wrote:
> On Thu, 2010-01-07 at 21:14 +0800, Mike Galbraith wrote:

> > Below is a complete retest.  Mind testing my hacklet?  I bet a nickle
> > it'll work at least as well as yours on your beefy boxen.
> 
> I tested your hacklet on below 2 machines as before.
> 
> Tigerton x86_64 machine: 16cpus(4P/4Cores), 40G mem
> IA64 machine: 32cpus(4P/4Cores/HT), 16G mem
> 
> Test1: vmark regression fix patch + pass affine target
> Test2: this hacklet
> 
> Compared with upstream 2.6.33-rc2, 
> Test1: Tigerton +3%, IA64 +15%
> Test2: Tigerton +3%, IA64 +10%
> 
> The test2 also improves on IA64, although not as good as test1.

Dang, I owe you a nickle.  Thanks a bunch for giving it a go.

Interesting result.  It's not really making much sense why you see a
peak gain, while I see peak loss.  Radical behavior difference :-/

I think the ramp only (and harder) approach is safer, but we'll see.

	-Mike

