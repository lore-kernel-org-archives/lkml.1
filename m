Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbYBRFOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbYBRFOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 00:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYBRFOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 00:14:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:45063 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbYBRFOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 00:14:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,369,1199692800"; 
   d="scan'208";a="299474253"
Subject: Re: 2.6.25-rc1: volanoMark 45% regression
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: balbir@linux.vnet.ibm.com
Cc: vatsa@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <47B91008.8050505@linux.vnet.ibm.com>
References: <1202895028.3027.27.camel@ymzhang>
	 <47B2BC2C.80100@linux.vnet.ibm.com>
	 <20080213120708.GA16231@linux.vnet.ibm.com>
	 <1202974901.3027.58.camel@ymzhang> <1203067505.3027.178.camel@ymzhang>
	 <47B91008.8050505@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 18 Feb 2008 13:11:45 +0800
Message-Id: <1203311505.3027.187.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-18 at 10:26 +0530, Balbir Singh wrote:
> Zhang, Yanmin wrote:
> >>
> >>>  Did you have
> >>> CONFIG_FAIR_USER_SCHED enabled in both cases?
> >> Yes.
> >>
> >> CONFIG_FAIR_GROUP_SCHED=y
> >> CONFIG_FAIR_USER_SCHED=y
> >>
> 
> Interesting that you have CONFIG_FAIR_USER_SCHED. Do you have any other users on
> the system (are they running anything at the time of the benchmark)?
No. As for volanoMark, I start volanoMark both server and client processes while
starting some system measurement tools such like vmstat/iostat/sar. All the processes
run under the same user.


>  Could you
> turn off CONFIG_FAIR_USER_SCHED  and turn on CONFIG_FAIR_GROUP_SCHED.
I will try.

>  I am going
> to run some tests with 2.6.25-rc2 and Volanomark and see how that goes.
Pls. set /proc/sys/kernel/sched_compat_yield=1 before starting test.

-yanmin


