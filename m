Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454Ab0AXXl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab0AXXl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 18:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205Ab0AXXlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 18:41:20 -0500
Received: from ip-85-161-27-212.eurotel.cz ([85.161.27.212]:34003 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751726Ab0AXXlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 18:41:19 -0500
Date: Wed, 20 Jan 2010 13:55:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, ananth@in.ibm.com,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
Message-ID: <20100120125546.GC1420@ucw.cz>
References: <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com> <1263467289.4244.288.camel@laptop> <1263498366.4875.25.camel@localhost.localdomain> <1263546228.4244.343.camel@laptop> <20100115093831.GC26396@in.ibm.com> <1263549014.4244.374.camel@laptop> <4B53213C.9050303@redhat.com> <1263739939.557.20938.camel@twins> <4B532508.4000806@redhat.com> <1263740506.557.20963.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263740506.557.20963.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-01-17 16:01:46, Peter Zijlstra wrote:
> On Sun, 2010-01-17 at 16:56 +0200, Avi Kivity wrote:
> > On 01/17/2010 04:52 PM, Peter Zijlstra wrote:
> 
> > > Also, if its fixed size you're imposing artificial limits on the number
> > > of possible probes.
> > >    
> > 
> > Obviously we'll need a limit, a uprobe will also take kernel memory, we 
> > can't allow people to exhaust it.
> 
> Only if its unprivilidged, kernel and root should be able to place as
> many probes until the machine keels over.

Well, it is address space that limits you in both cases...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
