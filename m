Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbZKCEUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbZKCEUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbZKCEUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:20:34 -0500
Received: from ozlabs.org ([203.10.76.45]:48014 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbZKCEUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:20:34 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Andi Kleen <ak@linux.intel.com>,
       Andy Henroid <andrew.d.henroid@intel.com>,
       Chris Leech <christopher.leech@intel.com>, cpufreq@vger.kernel.org,
       x86@kernel.org, Jeremy Fitzhardinge <jeremy@xensource.com>,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/14] Final cpumask conversion for x86
Date: Tue, 3 Nov 2009 14:50:33 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911031450.34491.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After these patches, I can build allmodconfig on 32 and 64 bit x86 with
the obsolete cpumask function definitions and names configured out.  After
3 more patches, we can finally allocate offstack cpumasks with less than
NR_CPUS bits.

I'd appreciate it if the various maintainers picked these up (most are
simple); Andrew, you seem best poised to annoy the others, do you want to
take these?

Thanks!
Rusty.
