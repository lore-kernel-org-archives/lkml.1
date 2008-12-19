Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbYLSTyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbYLSTyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 14:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYLSTyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 14:54:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbYLSTx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 14:53:59 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, yumiko.sugita.yf@hitachi.com,
       satoshi.oshima.fk@hitachi.com
Subject: Re: [PATCH] coredump_filter: enable to change the default filter
In-Reply-To: Hidehiro Kawai's message of  Friday, 19 December 2008 19:05:10 +0900 <494B71D6.3080602@hitachi.com>
References: <4940B426.6040509@hitachi.com>
	<20081211154349.5000.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081211151003.00572e04.akpm@linux-foundation.org>
	<20081211232205.ED188FC3AB@magilla.sf.frob.com>
	<494B71D6.3080602@hitachi.com>
X-Shopping-List: (1) Dyno-blast seducers
   (2) Tolerant inversions
   (3) Runcible digressions
Message-Id: <20081219195311.81C4AFC351@magilla.sf.frob.com>
Date: Fri, 19 Dec 2008 11:53:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It makes sense.  It also enables us to change coredump_filter for
> user mode helpers after the system was booted.

Right.

> However, we would need a special care for PID namespace if we use
> init's coredump_filter as default.  For a process with new PID
> namespace and new /proc, writing to /proc/1/coredump_filter doesn't
> mean changing default, although it's not a usual operation.

I'd figured that private PID namespaces with their own init would want
their own private settings for this default too.

> The reason why I suggested the boot parameter way is most users
> can change the default easily.  Some users have difficulty to
> change init scripts for various reasons.

I don't object to it deeply or anything.  
I just pointed out that we do already have an alternative.


Thanks,
Roland
