Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab0BHJxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 04:53:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:43355 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab0BHJxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 04:53:39 -0500
Date: Mon, 8 Feb 2010 01:53:49 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, rostedt@goodmis.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Tom Tromey <tromey@redhat.com>,
       Kyle Moffett <kyle@moffetthome.net>,
       "Frank Ch. Eigler" <fche@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       utrace-devel@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
       JimKeniston <jkenisto@us.ibm.com>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100208015349.36a12efe@infradead.org>
In-Reply-To: <20100208065425.GB1290@ucw.cz>
References: <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
	<alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>
	<m33a1tnbd9.fsf@fleche.redhat.com>
	<alpine.LFD.2.00.1001251332370.3574@localhost.localdomain>
	<m3636oh2rt.fsf@fleche.redhat.com>
	<alpine.LFD.2.00.1001261535510.17519@localhost.localdomain>
	<1264575134.4283.1983.camel@laptop>
	<alpine.LFD.2.00.1001270231520.24253@localhost.localdomain>
	<1264600792.31321.464.camel@gandalf.stny.rr.com>
	<4B607B1A.3080007@zytor.com>
	<20100208065425.GB1290@ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Feb 2010 07:54:25 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> > No, it has nothing to do with ring.  It has to do with modifying
> > code that another CPU could be executing at the same time, and with
> > modifying code on the same processor through another virtual alias
> > (they are different issues.)  The same issues apply regardless of
> > the CPL of the processor.
> 
> ...but these are always 'there could be cpu bugs around' issues,
> right? Like amd k6. AFAICT x86 always supported self-modifying code
> without any extra barriers needed...

self modifying code yes, cross modifying code no.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
