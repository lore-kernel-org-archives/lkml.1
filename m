Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbXFMIGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbXFMIGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 04:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756320AbXFMIGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 04:06:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53683 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756277AbXFMIGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 04:06:12 -0400
Date: Wed, 13 Jun 2007 10:06:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [tglx@linutronix.de: [patch-mm 00/23] High resolution timer
	updates and x86_64 support]
Message-ID: <20070613080601.GA5134@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Andi, Andrew,

any reaction to the submission for upstream inclusion below? We have put 
a lot of effort into it but this work is currently blocked by apparent 
silence from the x86_64 maintainer. Thanks,

	Ingo

----- Forwarded message from Thomas Gleixner <tglx@linutronix.de> -----

Date: Sun, 10 Jun 2007 09:43:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch-mm 00/23] High resolution timer updates and x86_64 support
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
	Andi Kleen <ak@suse.de>, Arjan van de Ven <arjan@infradead.org>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Chris Wright <chrisw@sous-sol.org>

The following patch series contains:

- dyntick bugfixes for -mm (caused by the cpuidle changes in ACPI)

- updates and improvements to high resolution timer / dynticks 

- high resolution timer / dynticks support for x86_64

The x86_64 support is based on an initial patch from Chris Wright. 
Thanks Chris !

The patch set has been tested in the -hrt and -rt trees for quite a 
while and the initial problems have been sorted out. Thanks to the folks 
from the PowerTop project for testing and feedback.

The -hrt tree at http://www.tglx.de/projects/hrtimers/2.6.22-rc4/ 
contains also an hpet force patch series from Venki Pallipadi, but I 
leave this up to Venki to send it mainline wards.

Thanks,

	tglx

-- 

----- End forwarded message -----
