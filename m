Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234Ab0ARLqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab0ARLqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 06:46:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620Ab0ARLqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 06:46:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:34454 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab0ARLqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 06:46:12 -0500
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
Date: Mon, 18 Jan 2010 12:45:40 +0100
Message-ID: <1263815140.4283.309.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 13:01 +0200, Avi Kivity wrote:
> If we reserve some address space, you don't add any heisenbugs (at 
> least, not any additional ones over emulation).  Even if we don't, 
> address space layout randomization means we're not keeping the address 
> space layout constant between runs anyway. 

Well, it still limits the number of probes to the reserved area. If you
want more you need to grow the area.. which then changes the state.

