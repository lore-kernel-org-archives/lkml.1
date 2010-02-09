Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab0BIVfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 16:35:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:40901 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab0BIVfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 16:35:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xeSuLTOSWerLz7jrUBqrBTDvQzbwy3x6Yq0TUw77v16XODMGGgzI86Iad9DLytDaNH
         jI3OhvuBMGe/YjvkvRL9ae/kp21ObNya4Vg7As8rShkOKkvDhZB49QkPPS6jIrzgtSmU
         E5OMKMIPFB62kvQONcafVGolAzVCaxchL3mTc=
Date: Wed, 10 Feb 2010 00:35:42 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC perf,x86] P4 PMU early draft
Message-ID: <20100209213542.GC5068@lenovo>
References: <20100208184504.GB5130@lenovo> <bd4cb8901002091313h3bc739fbi872567fdb219d752@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd4cb8901002091313h3bc739fbi872567fdb219d752@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 09, 2010 at 10:13:59PM +0100, Stephane Eranian wrote:
> Cyrill,
> 
> On Mon, Feb 8, 2010 at 7:45 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
...
> >
> > Stephane, I know you've been (and still is, right?) working on P4 driver
> > for libpmu (not sure if I remember correctly this name). Perhaps we should
> > take some ideas from there?
> >
> The library is called libpfm (perfmon) and libpfm4 (perf_events). It has
> support for Netburst (pentium4). It does the assignment of events to
> counters in user mode. I did not write the P4 support and it was a very long
> time ago. I don't recall all the details, except that this was really difficult.
> You may want to take a look at pfmlib_pentium4.c.

Yeah, I've a look taken on it. Interesting. Thanks! Will take more precise look
as only get spare time slot :)

> 
> I am still actively developing libpfm4 for perf_events. The P4 support is
> not available because I don't know how perf_events is going to support
> it. I'll update the library once that is settled.
> 
	-- Cyrill
