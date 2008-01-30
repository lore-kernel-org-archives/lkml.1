Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbYA3Njy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbYA3Njy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757504AbYA3Nje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:39:34 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:31292 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774AbYA3Njc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:39:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WuQeI+2O73VgeRLH/mJgbST2nHFGBK09vqr0fnesC8BHXYL9Hd+DZmGhEh1TsipVrhWuaQcL3D8wu0SJEQF96nHFF1lEZ9cAJxaRhp5pViSCjbEgf7sflIOWza/qvZckf/iFpZ0DfTU81k0315wxBEUjsnGIBAM9gYEKN2zWuiw=
Message-ID: <7c86c4470801300539g3c6e2cacxfafb69e81c7ffe7d@mail.gmail.com>
Date: Wed, 30 Jan 2008 14:39:29 +0100
From: "stephane eranian" <eranian@googlemail.com>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Subject: Re: ptrace API extensions for BTS
Cc: "Roland McGrath" <roland@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, markus.t.metzger@gmail.com
In-Reply-To: <029E5BE7F699594398CA44E3DDF55444014A581D@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <029E5BE7F699594398CA44E3DDF55444010F8D7C@swsmsx413.ger.corp.intel.com>
	 <20080130072557.EC73C26F9A7@magilla.localdomain>
	 <029E5BE7F699594398CA44E3DDF55444014A55DD@swsmsx413.ger.corp.intel.com>
	 <7c86c4470801300301n426f3ab4n94419db3a5553936@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF55444014A581D@swsmsx413.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus,

On Jan 30, 2008 1:52 PM, Metzger, Markus T <markus.t.metzger@intel.com> wrote:
> >From: stephane eranian [mailto:eranian@googlemail.com]
> >Sent: Mittwoch, 30. Januar 2008 12:01
>
> >You can get information about the perfmon2 project at:
> >http://perfmon2.sf.net
>
> I downloaded your patch for 2.6.23 and cloned your git repository.
>
> From a first glance, it looks like there is indeed a lot of overlap.
>
>
> >I would like to take a look at your patches. Where can I get them?
>
> You can find the changes in the mm branch of the x86 git. Do they keep
> the patches there, somewhere, as well?

I will take a look at what you have in -mm git.

>
> You should get the best overview if you look at arch/x86/kernel/ds.c,
> include/asm-x86/ds.h, include/asm-x86/ptrace-abi.h, and
> arch/x86/kernel/ptrace.c or simply grep for BTS.
>
OK.

>
> >My understanding at this point is that we would need to coordinate
> >access to the
> >DS_AREA. It would likely have to be mutually exclusive access.
>
> From a brief look at your patch, I would say that we should rather
> combine the configuration and collection part. They are very similar.
>
That's probably fine too. I'll let you know once I know more about your code.

> We might still want to provide different interfaces on top of it.
> In particular, I think the ptrace interface is most appropriate for
> debuggers.

I agree.

> >Now, there is some preliminary perf. MSR allocator in the kernel.
> >However, it does not know
> >of all available MSRs out there. It focuses on the counters mostly.
> >Perfmon, oprofile and
> >the NMI watchdog use it. I think it could be generalized to other MSR
> >(non-contiguous).
> >
> >I would be happy to work with you in refining this MSR allocator.
>
>
> Are you planning to get the perfmon patch into the kernel? Or do you
> want it to remain a separate patch?

The former, i.e., trying to merge with mainline.

>
> In the first case, we should try to merge the features. In the second
> case, refining the MSR allocator would probably be best.
>
>
