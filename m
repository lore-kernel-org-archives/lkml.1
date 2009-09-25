Return-Path: <linux-kernel-owner+w=401wt.eu-S1751677AbZIYKSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbZIYKSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 06:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbZIYKSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 06:18:14 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:58270 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbZIYKSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 06:18:14 -0400
In-Reply-To: <20090925110206.50ab8a20@lxorguk.ukuu.org.uk>
References: <20090924191642.GA19225@elte.hu>	<20090924193422.GB2533@elte.hu>	<20090925085119.2b77ea04@infradead.org>
	<20090925073512.GA10346@Krystal> <20090925110206.50ab8a20@lxorguk.ukuu.org.uk>
Subject: Re: Immediate values
X-KeepSent: 19654CE4:D069FD43-8025763C:0037FB4D;
 type=4; name=$KeepSent
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <ak@suse.de>, Anton Massoud <anton.massoud@ericsson.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Nathan Sidwell <nathan@codesourcery.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Lynch <rusty.lynch@intel.com>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Vamsi Krishna S <vamsi_krishna@in.ibm.com>
X-Mailer: Lotus Notes Release 8.5 December 05, 2008
Message-ID: <OF19654CE4.D069FD43-ON8025763C.0037FB4D-8025763C.00389751@uk.ibm.com>
From: Richard J Moore <richardj_moore@uk.ibm.com>
Date: Fri, 25 Sep 2009 11:18:07 +0100
X-MIMETrack: Serialize by Router on D06ML065/06/M/IBM(Release 8.0.1|February 07, 2008) at
 25/09/2009 11:18:13
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Alan Cox <alan@lxorguk.ukuu.org.uk> wrote on 25/09/2009 11:02:06:


>
> There was considerable discussion abut this when the kprobe stuff went
> in. If I remember rightly it was stated by someone @intel.com then that
> int3 was ok (even though its not strictly documented as such). The same
> is not true for all instructions on all x86 processors unfortunately.
>
> Alan

Alan, I had that discussion with Intel, and yes int3 is a special case
because of the interrupt processing associated with it. The discussion
went along this lines: int3 is practically useless in an MP environment
if it's trouble by the cross-modifying erratum.

I suppose it is possible the more recent microarchitectures have
changed things. And yes, we might need to have that conversation again.

Richard



