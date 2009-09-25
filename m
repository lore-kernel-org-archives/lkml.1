Return-Path: <linux-kernel-owner+w=401wt.eu-S1751497AbZIYKPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbZIYKPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 06:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbZIYKPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 06:15:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:33367 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbZIYKPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 06:15:17 -0400
Date: Fri, 25 Sep 2009 12:14:49 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Rusty Lynch <rusty.lynch@intel.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Vamsi Krishna S <vamsi_krishna@in.ibm.com>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nathan Sidwell <nathan@codesourcery.com>,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Anton Massoud <anton.massoud@ericsson.com>,
       Richard J Moore <richardj_moore@uk.ibm.com>
Subject: Re: Immediate values
Message-ID: <20090925121449.7bb27b61@infradead.org>
In-Reply-To: <20090925110206.50ab8a20@lxorguk.ukuu.org.uk>
References: <20090924191642.GA19225@elte.hu>
	<20090924193422.GB2533@elte.hu>
	<20090925085119.2b77ea04@infradead.org>
	<20090925073512.GA10346@Krystal>
	<20090925110206.50ab8a20@lxorguk.ukuu.org.uk>
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

On Fri, 25 Sep 2009 11:02:06 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Then, following your advice, kprobes should be re-designed to do a
> > stop_machine around the int3 breakpoint insertion ? And gdb
> > should be stopping all threads of a target process before inserting
> > a breakpoint. Therefore, I do not seem to be the only one confused
> > about Intel statement on this issue.
> 
> There was considerable discussion abut this when the kprobe stuff went
> in. If I remember rightly it was stated by someone @intel.com then
> that int3 was ok (even though its not strictly documented as such).
> The same is not true for all instructions on all x86 processors
> unfortunately.

specifically, using int3 *and then going back to the old value*.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
