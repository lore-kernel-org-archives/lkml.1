Return-Path: <linux-kernel-owner+w=401wt.eu-S1751734Ab0ASRol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab0ASRol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 12:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137Ab0ASRok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 12:44:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab0ASRoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 12:44:38 -0500
Date: Tue, 19 Jan 2010 12:44:14 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Joshua Pincus <joshua.pincus@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>, peterz@infradead.org,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: HW breakpoints perf_events request
Message-ID: <20100119174414.GE16096@redhat.com>
References: <bc915a051001131745m6fb70dcbx29b9d35f6fd7106c@mail.gmail.com> <87ljg1fn3u.fsf@basil.nowhere.org> <bc915a051001131821x6cdd3470lf72e8c02a897ea3@mail.gmail.com> <20100114092350.GF12241@basil.fritz.box> <bc915a051001141003s766689beue73800a1308d957e@mail.gmail.com> <20100118110406.GC5256@nowhere> <y0maawbid91.fsf@fche.csb> <20100119145027.GB8061@nowhere> <20100119151210.GC16096@redhat.com> <20100119162059.GF8061@nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100119162059.GF8061@nowhere>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, Jan 19, 2010 at 05:21:02PM +0100, Frederic Weisbecker wrote:
> [...]
> But I rather hope we can extend ptrace interface to handle such new
> needs instead (ie: having a more scalable breakpoint interface
> support by ptrace).

According to its maintainer, ptrace per se appears to be not well
suited for extensions that affect control flow, but maybe.
(http://www.mail-archive.com/utrace-devel@redhat.com/msg02276.html)


> > Another is using the gdbstub, extended with gdb watchpoint support (Z*
> > packets), which would tie into the hw-breakpoint system directly.
> > [...]

> Is this gdbstub an interface to utrace?
> This: http://lwn.net/Articles/364268/ ?

Yes, but I wouldn't think of it that way ("an interface to utrace").
Yes, it uses utrace, but that's an implementation detail.  To
userspace it presents gdb's existing wire protocol for debugging
processes.


> > > Do you plan a resubmission soon?
> > 
> > Utrace core has been resubmitted at the end of December
> > (http://lkml.org/lkml/2009/12/17/466), with no further comments
> > received.
> 
> Hmm, there has been deep review from Peter, IIRC.

I haven't seen any after that particular resubmission.  Rather, there
has been lots of discussion lately about *uprobes*, which is a
separate & optional process breakpoint management layer that happens
to use utrace and happens to be used by systemtap and the gdbstub.


- FChE
