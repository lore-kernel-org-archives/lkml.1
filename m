Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbXLEVQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbXLEVQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 16:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbXLEVP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 16:15:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46020 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbXLEVP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 16:15:57 -0500
X-Greylist: delayed 2299 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Dec 2007 16:15:57 EST
Subject: Re: Scheduler behaviour
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Holger.Wolf@de.ibm.com
Cc: mingo@elte.hu, schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org
In-Reply-To: <475706E2.50805@linux.vnet.ibm.com>
References: <475706E2.50805@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 05 Dec 2007 22:15:02 +0100
Message-Id: <1196889302.6353.29.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-12-05 at 21:15 +0100, Holger Wolf wrote:

> We discovered performance degradation with dbench when using kernel 2.6.23 compared to kernel 2.6.22.

We've fixed a lot of regressions and made a lot of other changes to the
scheduler since .23. Could you please try the backport of the latest
scheduler on top of .23 to see if any of our recent work solved your
problem? (using a backport against .23 or even .22 allows you to test
just the scheduler changes in isolation)

http://people.redhat.com/mingo/cfs-scheduler/sched-cfs-v2.6.22.13-v24.patch
http://people.redhat.com/mingo/cfs-scheduler/sched-cfs-v2.6.23.9-v24.patch

Also, it could be dbench is one of those benchmarks that favours
unfairness, I seem to remember so.. still we should not regress too much
without a very good reason.



