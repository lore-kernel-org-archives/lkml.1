Return-Path: <linux-kernel-owner+w=401wt.eu-S1761929AbXE1JM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761929AbXE1JM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 05:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761456AbXE1JMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 05:12:44 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2263 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760882AbXE1JMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 05:12:43 -0400
Date: Mon, 28 May 2007 10:12:24 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>, Ashok Raj <ashok.raj@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [BUG] CPU hotplug: system hang on CPU hot remove during oprofile
Message-ID: <20070528091224.GA26046@flint.arm.linux.org.uk>
Mail-Followup-To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Srivatsa Vaddagiri <vatsa@in.ibm.com>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Nathan Lynch <nathanl@austin.ibm.com>,
	Joel Schopp <jschopp@austin.ibm.com>,
	Ashok Raj <ashok.raj@intel.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Gautham R Shenoy <ego@in.ibm.com>
References: <87k5utblbp.wl%takeuchi_satoru@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k5utblbp.wl%takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 01:53:30PM +0900, Satoru Takeuchi wrote:
> I found a bug on CPU hotplug. If oprofile is running, CPU hot remove causes
> system hang. I only confirm that this problem occurs on my ia64 box. I'm glad
> if someone report about other arch.

oprofile is not CPU hotplug safe.  (It should probably be made so,
but I think that would require a redesign, or at least a rewrite of
the backends.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
