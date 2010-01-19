Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189Ab0ASOun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab0ASOun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478Ab0ASOum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:50:42 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:57711 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0ASOud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:50:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NGi6h2ce8ZQsHcu9W4GmLvIHSFFxT+0P3Ct0Rtzn+acVQ9q54OkuUUd652zXMghfUs
         wDll1hc6HIUYQgqAYLY8slhwLOBFyaSbEbQSUHGGyZ1SBR/W/nEdlbBeBdAw3nkm1tTM
         VmoyI5KcFYxL1Q0UdHOp0gGW+hugaFM8XUpj4=
Date: Tue, 19 Jan 2010 15:50:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Joshua Pincus <joshua.pincus@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>, peterz@infradead.org,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: HW breakpoints perf_events request
Message-ID: <20100119145027.GB8061@nowhere>
References: <bc915a051001131745m6fb70dcbx29b9d35f6fd7106c@mail.gmail.com> <87ljg1fn3u.fsf@basil.nowhere.org> <bc915a051001131821x6cdd3470lf72e8c02a897ea3@mail.gmail.com> <20100114092350.GF12241@basil.fritz.box> <bc915a051001141003s766689beue73800a1308d957e@mail.gmail.com> <20100118110406.GC5256@nowhere> <y0maawbid91.fsf@fche.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0maawbid91.fsf@fche.csb>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 11:33:46AM -0500, Frank Ch. Eigler wrote:
> Frederic Weisbecker <fweisbec@gmail.com> writes:
> 
> > [...]
> > What about extending ptrace to support a new type of
> > breakpoint debugging interface?
> 
> This is the sort of reason why the utrace-gdbstub prototype was
> constructed.  It should allow in-kernel implementation of the
> multithreaded gdb extensions.  (By the way, it can already use uprobes
> rather than userspace-managed breakpoints.)


Can utrace somehow meet Joshua's needs? I'm not sure what kind
of interface it can offer for that. The fact is I don't know
very well utrace :)  Do you plan a resubmission soon?

Thanks.

