Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143Ab0ARLpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab0ARLpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 06:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471Ab0ARLpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 06:45:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37256 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab0ARLo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 06:44:57 -0500
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: ananth@in.ibm.com, Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B543F93.3060509@redhat.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>
	 <1263467289.4244.288.camel@laptop>
	 <1263498366.4875.25.camel@localhost.localdomain>
	 <1263546228.4244.343.camel@laptop>  <20100115093831.GC26396@in.ibm.com>
	 <1263549014.4244.374.camel@laptop>  <4B53213C.9050303@redhat.com>
	 <1263739939.557.20938.camel@twins>  <4B5325CF.5000001@redhat.com>
	 <1263740593.557.20967.camel@twins>  <4B53661A.9090907@redhat.com>
	 <1263800752.4283.19.camel@laptop>  <4B543F93.3060509@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 12:44:32 +0100
Message-ID: <1263815072.4283.305.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 13:01 +0200, Avi Kivity wrote:
> 
> You've made it clear that you don't like it, but not why.
> 
> The kernel already manages the user's address space (except for 
> MAP_FIXED which is unreliable unless you've already reserved the address 
> space).  I don't see why adding a vma for debugging is so horrible. 

Well, the kernel only does what the user (and loader) tell it through
mmap(). Other than that we never (except this VDSO thing) inject vmas,
and I see no reason to start doing that now.

