Return-Path: <linux-kernel-owner+w=401wt.eu-S1945963AbXC3Jqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945963AbXC3Jqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 05:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945964AbXC3Jqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 05:46:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945963AbXC3Jqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 05:46:48 -0400
Subject: Re: [PATCH 1/5] RT kernel: force detect HPET from PCI space
From: Ingo Molnar <mingo@redhat.com>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070222170616.A27455@unix-os.sc.intel.com>
References: <20070222170616.A27455@unix-os.sc.intel.com>
Content-Type: text/plain
Date: Fri, 30 Mar 2007 11:46:43 +0200
Message-Id: <1175248003.6157.43.camel@earth4>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 17:06 -0800, Venkatesh Pallipadi wrote:
> Patchset enables force detection of HPET, when it is not listed by
> BIOS.
> and enables use of HPET as a event source. HPET timers
> configures in stamdard interrupt mode can be used as dependable per
> CPU timer
> on laptops that are known to have LAPIC stoppage with ACPI C3 state.

(sorry about the belated reply)

cool patchset! I suspect the most logical place to start this would be
on upstream 32-bit, which has the hpet clockevents changes already.
Plus the i386 and x86_64 hpet code should be unified.

	Ingo

