Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825Ab0ALJgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab0ALJgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 04:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379Ab0ALJgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 04:36:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:49369 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285Ab0ALJgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 04:36:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,261,1262592000"; 
   d="bz2'66?scan'66,208,49,66";a="586401696"
Subject: Re: tbench regression with 2.6.33-rc1
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1263286449.4244.101.camel@laptop>
References: <1261739467.10685.18.camel@minggr.sh.intel.com>
	 <1263211680.4244.50.camel@laptop>
	 <1263226612.6290.9.camel@marge.simson.net>
	 <1263258546.3598.19.camel@minggr.sh.intel.com>
	 <1263286449.4244.101.camel@laptop>
Content-Type: multipart/mixed; boundary="=-VaoQIxpIlBn/qH7WtRko"
Date: Tue, 12 Jan 2010 17:20:24 +0800
Message-Id: <1263288024.3598.52.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VaoQIxpIlBn/qH7WtRko
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2010-01-12 at 16:54 +0800, Peter Zijlstra wrote:
> On Tue, 2010-01-12 at 09:09 +0800, Lin Ming wrote:
> > I test this patch applied to 2.6.33-rc3, but no help on tbench
> > regression. 
> 
> How stable is this regression on your machines? That is, can you bisect
> it? Me and Mike seem to have no luck bisecting it, ending up at totally
> unrelated patches and the like :/

I tried bisect weeks ago, but the bisect result is not stable.

Then I tried another way to reproduce this regression.
I picked up most scheduler related patches that merged into 2.6.33-rc1,
and applied them to 2.6.32, then the ~4% regression was reproduced.

But again, the bisect result among these scheduler related patches was
not stable either. The regression seems not caused by one single patch,
but the accumulation of some patches.

You may try the attached scheduler patches to reproduce the regression.

git checkout v2.6.32
git am sched-2.6.33-rc1.patch

Lin Ming




--=-VaoQIxpIlBn/qH7WtRko
Content-Disposition: attachment; filename="sched-2.6.33-rc1.patch.tar.bz2"
Content-Type: application/x-bzip-compressed-tar; name="sched-2.6.33-rc1.patch.tar.bz2"
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWVxWWYMAAJN//8ZADEBR53+gMFBIMH5nXggACAAEAQAAYkAEgAQEAAQIIACUDUJq
epk00eUANA0aNojTQG0J6mgyqek0NNNGJoaNDJkZME0aZMho0vVlH8ggdkwQRi/IBBHzAd7h3MJK
lMJQIABH3Ci0oUiByxfWvKuiNKo4EgEmwAXQWgp0LlzyOh9AW7ARxJpbhnwi+8Ub3mrPHJ0nhnQy
maJxntOvyWkMD/dgh/VRW2YT2Zqqq/rWq5FttMCEA/i7kinChILisswY


--=-VaoQIxpIlBn/qH7WtRko--

