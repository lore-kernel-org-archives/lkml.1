Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065Ab0AQPB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0AQPB7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 10:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791Ab0AQPB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 10:01:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:51708 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab0AQPBz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 10:01:55 -0500
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
In-Reply-To: <4B532508.4000806@redhat.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>
	 <1263467289.4244.288.camel@laptop>
	 <1263498366.4875.25.camel@localhost.localdomain>
	 <1263546228.4244.343.camel@laptop>  <20100115093831.GC26396@in.ibm.com>
	 <1263549014.4244.374.camel@laptop>  <4B53213C.9050303@redhat.com>
	 <1263739939.557.20938.camel@twins>  <4B532508.4000806@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 17 Jan 2010 16:01:46 +0100
Message-ID: <1263740506.557.20963.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-17 at 16:56 +0200, Avi Kivity wrote:
> On 01/17/2010 04:52 PM, Peter Zijlstra wrote:

> > Also, if its fixed size you're imposing artificial limits on the number
> > of possible probes.
> >    
> 
> Obviously we'll need a limit, a uprobe will also take kernel memory, we 
> can't allow people to exhaust it.

Only if its unprivilidged, kernel and root should be able to place as
many probes until the machine keels over.
