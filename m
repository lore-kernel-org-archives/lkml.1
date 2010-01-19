Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902Ab0ASVYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab0ASVYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837Ab0ASVYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:24:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:4260 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717Ab0ASVY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:24:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,305,1262592000"; 
   d="scan'208";a="765578917"
Subject: Re: [patch] x86, irq: don't block IRQ0_VECTOR..IRQ15_VECTOR's on
 all cpu's
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B561D37.9040007@kernel.org>
References: <1263932453.2814.52.camel@sbs-t61.sc.intel.com>
	 <4B561D37.9040007@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 19 Jan 2010 13:23:20 -0800
Message-Id: <1263936200.2814.55.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 12:59 -0800, Yinghai Lu wrote:
> when PIC is used, if the user is setting /proc/irq/[0-15]/smp_affinity to cpu other than 0,
> we need to prevent that happen.

If it is handled by i8259A_chip, then even today we won't be able to
change smp_affinity because of no "set_affinity" for that irq_chip.

thanks,
suresh

