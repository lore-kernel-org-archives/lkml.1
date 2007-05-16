Return-Path: <linux-kernel-owner+w=401wt.eu-S1762637AbXEPQat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762637AbXEPQat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756984AbXEPQaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:30:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757804AbXEPQai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:30:38 -0400
Date: Wed, 16 May 2007 12:30:00 -0400
From: Dave Jones <davej@redhat.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Bob Tracy <rct@gherkin.frus.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Joachim Deguara <joachim.deguara@amd.com>
Subject: Re: [BUG] (regression) AMD k6-III/450 won't boot w/2.6.22-rc1
Message-ID: <20070516163000.GE30166@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Chuck Ebbert <cebbert@redhat.com>, Bob Tracy <rct@gherkin.frus.com>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
	Joachim Deguara <joachim.deguara@amd.com>
References: <20070516131558.E15BFDBA1@gherkin.frus.com> <464B28F2.9050400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464B28F2.9050400@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 11:53:22AM -0400, Chuck Ebbert wrote:
 > Bob Tracy wrote:
 > > Jan Engelhardt wrote:
 > >>> On Tue, 15 May 2007 22:13:14 -0500 (CDT) Bob Tracy wrote:
 > >>>
 > >>>> The 2.6.22-rc1 boot panics early in amd_mcheck_init() with my k6-III/450.
 > 
 > > Intel machine check architecture supported.
 > > general protection fault: 0000 [#1]
 > > PREEMPT
 > > Modules linked in:
 > > CPU:   0
 > > EIP: 0060:[<c01079f4>]  Not tainted VLI
 > > EFLAGS: 00010286   (2.6.22-rc1 #1)
 > > EIP is at amd_mcheck_init+0x2b/0xc3
 > > 
 > 
 > rdmsr with ecx == 0x179 (Machine Check Global Capabilities Register)
 > 
 > Probably K6 doesn't have that.

sounds right. Intel style MCE capability was introduced with the Athlon
on AMD systems iirc.

 > Caused by:
 > 
 > 	[PATCH] i386: check capability

Though this would imply that Bobs K6-3 is reporting that it does have
that bit in its cpuid flags.

Bob, can you send your /proc/cpuinfo and dmesg |grep CPU  ?

	Dave

-- 
http://www.codemonkey.org.uk
