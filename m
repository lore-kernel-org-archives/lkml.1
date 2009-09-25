Return-Path: <linux-kernel-owner+w=401wt.eu-S1752401AbZIYGve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbZIYGve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 02:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbZIYGvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 02:51:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:43167 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbZIYGvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 02:51:31 -0400
Date: Fri, 25 Sep 2009 08:51:19 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Immediate values
Message-ID: <20090925085119.2b77ea04@infradead.org>
In-Reply-To: <20090924193422.GB2533@elte.hu>
References: <20090924191642.GA19225@elte.hu>
	<20090924193422.GB2533@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 21:34:22 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > I would like to get an official ACK or NAK for this patching
> > technique from inside Intel, and preferrably from AMD as well.  If
> > it does work as described it would provide a very clean way to do
> > one-shot alternative functions, which probably would be higher
> > value than immediate data values.
> 
> Sounds tempting. Things like the CONFIG_SECURITY hookery could use it?
> 
> But ... since it's patched under stopmachine, is there any reason why 
> this wouldnt work?
> 

stopmachine is fine.

more aggressive tricks are rather dicey.

(cross modifying code that's being executed in ring 0 is ... not
something CPU designers had in mind)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
