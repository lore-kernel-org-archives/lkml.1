Return-Path: <linux-kernel-owner+w=401wt.eu-S1752245AbZIYKB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbZIYKB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 06:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZIYKB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 06:01:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45941 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752134AbZIYKBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 06:01:55 -0400
Date: Fri, 25 Sep 2009 11:02:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20090925110206.50ab8a20@lxorguk.ukuu.org.uk>
In-Reply-To: <20090925073512.GA10346@Krystal>
References: <20090924191642.GA19225@elte.hu>
	<20090924193422.GB2533@elte.hu>
	<20090925085119.2b77ea04@infradead.org>
	<20090925073512.GA10346@Krystal>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Then, following your advice, kprobes should be re-designed to do a
> stop_machine around the int3 breakpoint insertion ? And gdb
> should be stopping all threads of a target process before inserting a
> breakpoint. Therefore, I do not seem to be the only one confused about
> Intel statement on this issue.

There was considerable discussion abut this when the kprobe stuff went
in. If I remember rightly it was stated by someone @intel.com then that
int3 was ok (even though its not strictly documented as such). The same
is not true for all instructions on all x86 processors unfortunately.

Alan
