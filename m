Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997Ab0AQOwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab0AQOwe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 09:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939Ab0AQOwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 09:52:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:33631 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab0AQOwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 09:52:32 -0500
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
In-Reply-To: <4B53213C.9050303@redhat.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>
	 <1263467289.4244.288.camel@laptop>
	 <1263498366.4875.25.camel@localhost.localdomain>
	 <1263546228.4244.343.camel@laptop>  <20100115093831.GC26396@in.ibm.com>
	 <1263549014.4244.374.camel@laptop>  <4B53213C.9050303@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 17 Jan 2010 15:52:19 +0100
Message-ID: <1263739939.557.20938.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-17 at 16:39 +0200, Avi Kivity wrote:
> On 01/15/2010 11:50 AM, Peter Zijlstra wrote:
> > As previously stated, I think poking at a process's address space is an
> > utter no-go.
> >    
> 
> Why not reserve an address space range for this, somewhere near the top 
> of memory?  It doesn't have to be populated if it isn't used.

Because I think poking at a process's address space like that is gross.
Also, if its fixed size you're imposing artificial limits on the number
of possible probes.


