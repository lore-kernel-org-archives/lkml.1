Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbXKCMJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbXKCMJs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 08:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbXKCMJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 08:09:29 -0400
Received: from ozlabs.org ([203.10.76.45]:54743 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199AbXKCMJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 08:09:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18220.24362.604297.53633@cargo.ozlabs.ibm.com>
Date: Sat, 3 Nov 2007 22:44:42 +1100
From: Paul Mackerras <paulus@samba.org>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       "Christian Borntraeger" <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] Restore deterministic CPU accounting on powerpc
In-Reply-To: <661de9470711030202x24d0186cuc96a70156ecfa23f@mail.gmail.com>
References: <18218.44089.274628.680088@cargo.ozlabs.ibm.com>
	<661de9470711030202x24d0186cuc96a70156ecfa23f@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh writes:

> So, scaled accounting will not be available if
> CONFIG_VIRT_CPU_ACCOUNTING is defined? Am I reading this correctly

No, what makes you think that?  If VIRT_CPU_ACCOUNTING=y it is the
responsibility of the arch's account_process_tick to update the scaled
stats.  And the powerpc version does that by calling
account_user_time_scaled().

Paul.
