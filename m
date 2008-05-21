Return-Path: <linux-kernel-owner+w=401wt.eu-S932204AbYEUJQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbYEUJQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 05:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbYEUJQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 05:16:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59117 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbYEUJQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 05:16:31 -0400
Subject: Re: /proc/lock_stat "stuck"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <483313DD.2020904@hp.com>
References: <483313DD.2020904@hp.com>
Content-Type: text/plain
Date: Wed, 21 May 2008 11:16:20 +0200
Message-Id: <1211361380.6463.63.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-20 at 14:09 -0400, Alan D. Brunelle wrote:
> I'm attempting to use /proc/lock_stat to gather some information during
> some benchmarking runs, but what I find happens is as follows:
> 
> 1. I boot the system - 2.6.26-rc3 kernel + CONFIG_LOCK_STAT=y
> 
> 2. I can then look at /proc/lock_stat, and it has valid-looking values
> 
> 3. I wait a while, do some stuff, but when I look at /proc/lock_stat
> again the values have not changed.
> 
> 4. If I clear the counters - echo 0 > /proc/lock_stat - the counters
> never increase, and no information besides the headers are output when I
> cat /proc/lock_stat.
> 
> 
> Is there something that one needs to do to get counter updates?

Did you get lockdep warnings? Those disable all lock debugging,
including lockstat.

