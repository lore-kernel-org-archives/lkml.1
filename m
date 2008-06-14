Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419AbYFNXbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbYFNXbi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 19:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbYFNXba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 19:31:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39940
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754994AbYFNXb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 19:31:29 -0400
Date: Sat, 14 Jun 2008 16:31:29 -0700 (PDT)
Message-Id: <20080614.163129.80352314.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, bunk@kernel.org,
       akpm@linux-foundation.org, protasnb@gmail.com
Subject: Re: 2.6.26-rc6-git2: Reported regressions from 2.6.25
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0806141423500.2949@woody.linux-foundation.org>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
	<alpine.LFD.1.10.0806141423500.2949@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Jun 2008 14:42:05 -0700 (PDT)

> On Sat, 14 Jun 2008, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10908
> > Subject		: IPF Montvale machine panic when running a network-relevent testing
> > Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > Date		: 2008-06-13 8:19 (2 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121334523711437&w=4
> 
> I think this got fixed by ec0a196626bd12e0ba108d7daa6d95a4fb25c2c5: "tcp: 
> Revert 'process defer accept as established' changes".

No, this is looking like a different bug.

The behavior of that bug would not usually be a crash, but
rather stuck connections, and I severely doubt anything in
that specweb test setup is using the deferred-accept option
which is a requirement for hitting those problems.

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10903
> > Subject		: ssh connections hang with 2.6.26-rc5
> > Submitter	: Didier Raboud <didier@raboud.com>
> > Date		: 2008-06-13 02:39 (2 days old)
> 
> I think this is likely fixed by the same revert as above.

I think this is also a seperate bug.  Ilpo has asked the reporter for
more information.
