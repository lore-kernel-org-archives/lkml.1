Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424Ab0A0SxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab0A0SxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 13:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735Ab0A0SxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 13:53:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52772 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab0A0SxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 13:53:23 -0500
X-Authority-Analysis: v=1.0 c=1 a=7U3hwN5JcxgA:10 a=bSiTVtOL1o2ubSs1LzUA:9 a=cb8bMr6cuZYwx2ny22UZDkNwuUUA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: linux-next: add utrace tree
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Tom Tromey <tromey@redhat.com>,
       Kyle Moffett <kyle@moffetthome.net>,
       "Frank Ch. Eigler" <fche@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       utrace-devel@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
       JimKeniston <jkenisto@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <4B607B1A.3080007@zytor.com>
References: <20100121013822.28781960.sfr@canb.auug.org.au>
	 <20100122005147.GD22003@redhat.com>
	 <20100121170541.7425ff10.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain>
	 <20100122182827.GA13185@redhat.com> <20100122200129.GG22003@redhat.com>
	 <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>
	 <20100122221348.GA4263@redhat.com>
	 <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>
	 <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
	 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
	 <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>
	 <m33a1tnbd9.fsf@fleche.redhat.com>
	 <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain>
	 <m3636oh2rt.fsf@fleche.redhat.com>
	 <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain>
	 <1264575134.4283.1983.camel@laptop>
	 <alpine.LFD.2.00.1001270231520.24253@localhost.localdomain>
	 <1264600792.31321.464.camel@gandalf.stny.rr.com>
	 <4B607B1A.3080007@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 27 Jan 2010 13:53:19 -0500
Message-ID: <1264618399.31321.470.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 09:42 -0800, H. Peter Anvin wrote:
> On 01/27/2010 05:59 AM, Steven Rostedt wrote:

> > I think the issue was that ring 0 was never meant to do that, where as,
> > ring 3 does it all the time. Doesn't the dynamic library modify its
> > text?
> > 
> 
> No, it has nothing to do with ring.  It has to do with modifying code
> that another CPU could be executing at the same time, and with modifying
> code on the same processor through another virtual alias (they are
> different issues.)  The same issues apply regardless of the CPL of the
> processor.

Thanks for clarifying.

-- Steve


