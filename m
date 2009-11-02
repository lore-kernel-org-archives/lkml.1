Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbZKBFhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbZKBFhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 00:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbZKBFhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 00:37:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:46519 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbZKBFhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 00:37:31 -0500
Date: Sun, 1 Nov 2009 21:38:39 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>, Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [PATCH 1/6] perf/core: Provide a kernel-internal interface to
 get to performance counters
Message-ID: <20091101213839.28b4054a@infradead.org>
In-Reply-To: <19182.22063.788927.708332@cargo.ozlabs.ibm.com>
References: <4AE55B1B.2030006@web.de>
	<1257109753-6464-2-git-send-email-fweisbec@gmail.com>
	<19182.22063.788927.708332@cargo.ozlabs.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009 14:46:55 +1100
Paul Mackerras <paulus@samba.org> wrote:

> Frederic Weisbecker writes:
> 
> >  /*
> > + * perf_event_create_kernel_counter
> > + * MUST be called from a kernel thread.
> 
> Why?  The reason for this requirement isn't obvious to me.  It would
> be good to have the reason documented in the comment for the sake of
> people modifying the code in future.

because if you call it from another context it will attach to that
context... and go away when that context goes away...



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
