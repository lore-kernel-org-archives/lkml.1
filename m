Return-Path: <linux-kernel-owner+w=401wt.eu-S1764246AbXIKSiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764246AbXIKSiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 14:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762370AbXIKSiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:38:09 -0400
Received: from www.osadl.org ([213.239.205.134]:60629 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758761AbXIKSiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:38:08 -0400
Subject: Re: clockevents: fix resume logic
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <20070911112531.80bac380.akpm@linux-foundation.org>
References: <200707220159.l6M1xBgH001236@hera.kernel.org>
	 <200709111323.56030.rjw@sisk.pl>
	 <20070911042228.1ef690e0.akpm@linux-foundation.org>
	 <200709111409.13796.rjw@sisk.pl>
	 <20070911112531.80bac380.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 20:38:03 +0200
Message-Id: <1189535883.5235.13.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-11 at 11:25 -0700, Andrew Morton wrote:
> > It evidently assumes cpuidle to be present, which is not in the mainline.
> 
> Bear in mind that the cpuidle patch fixes resume-from-ram when cpuidle is
> disabled in config.
> 
> > It seems to me that the total effect of this one and the hackpatch is that
> > the C states are not handled any more.
> 
> hm.
> 
> dmesg without the cpuidle patch: http://userweb.kernel.org/~akpm/dmesg-bad.txt
> dmesg with the cpuidle patch: http://userweb.kernel.org/~akpm/dmesg-good.txt
> difference: http://userweb.kernel.org/~akpm/dmesg-diff.txt
> 
> there doesn't seem to be a lot of difference in the time handling, except
> there are large changes in when things happen in the bootup sequence.

The question is whether the system goes into C2 with the patch applied.

Can you please provide the output of /proc/acpi/processor/CPU0/power for
both the bad and the good one ?

	tglx


