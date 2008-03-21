Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbYCUMxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbYCUMxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 08:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbYCUMxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 08:53:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:23951 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbYCUMxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 08:53:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l1DgfFdgQiB6QKZJp6L/fK7Q3VWarnfqtXt0r+nvuT7MulcYAeFqKpBWW5hxKy3bcVWbW/5ic6I++KDKgzwYfKV1Lx5EOTUwZPu5Vf3y875PiWeOI3vQpo5WnIBjpPK6ll22ypdd2KqjiEnn27G/Os6ZpIqv15lk1yCj0n6+VaM=
Message-ID: <e2e108260803210552i4cdef6a5qf8f5076eaac2cf03@mail.gmail.com>
Date: Fri, 21 Mar 2008 13:52:59 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: quicklists confuse meminfo
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <200803111507.20870.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
	 <20080309114640.85c9c3eb.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0803100851560.23575@schroedinger.engr.sgi.com>
	 <200803111507.20870.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 5:07 AM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>  [ ... ]
>
>  This is insane. We add more and more of this NUMA and cpuset and anti-frag
>  and page zeroing logic to the page allocator, and then decide that we
>  don't actually need to obey any of those rules when we're running lat_proc.
>
>  You will never be able to make the page allocator faster than a single list
>  of pages. The reason is because we actually *want* some of these checks and
>  heuristics in the page allocator.
>
>  And I doubt a list of zeroed pages is the right approach. That's just
>  adding more complexity for lat_proc AFAIKS.

Is anyone currently working on this
(http://bugzilla.kernel.org/show_bug.cgi?id=9991) ? I think this
should either be fixed or documented as a known issue.

Bart.
