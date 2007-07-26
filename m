Return-Path: <linux-kernel-owner+w=401wt.eu-S1761382AbXGZDVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761382AbXGZDVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 23:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756867AbXGZDVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 23:21:43 -0400
Received: from smtp-out.google.com ([216.239.45.13]:56258 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226AbXGZDVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 23:21:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=opDije1rbkPrDXQDStQOmVsS6TlHnme8173Kp6BHW9z3jYg0xSrevmZkqUy+bTKB2
	xKOvH3tOSzvmunu1hqj8g==
Message-ID: <4517d1380707252021j1c7af370wcd23edebd3085c51@mail.gmail.com>
Date: Wed, 25 Jul 2007 20:21:28 -0700
From: "Masoud Sharbiani" <masouds@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: i386-show-unhandled-signals-v3
Cc: "Andi Kleen" <ak@suse.de>, "Kirill Korotaev" <dev@openvz.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070725165805.1bcd5a02.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070718154759.GA26425@google.com> <46A76210.5020903@openvz.org>
	 <200707251657.44217.ak@suse.de>
	 <20070725140455.cbbc0dde.akpm@linux-foundation.org>
	 <4517d1380707251407v178068baxcc76a86f8337cc27@mail.gmail.com>
	 <20070725162528.7d485ff8.akpm@linux-foundation.org>
	 <20070725234005.GA11292@google.com>
	 <20070725165805.1bcd5a02.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 25 Jul 2007 16:40:06 -0700
> masouds@google.com (Masoud Asgharifard Sharbiani) wrote:
>
> > > Look: if there's a way in which an unprivileged user can trigger a printk
> > > we fix it, end of story.  I don't know why this even slightly
> > > controversial.
> > >
> >
> > Fair enough. Here it is:
>
> My favourite words.
>
> > ---------------
> > Hello,
> > This patch makes the i386 behave the same way that x86_64 does when a
> > segfault happens. A line gets printed to the kernel log so that tools
> > that need to check for failures can behave more uniformly between
> > different kernels. Like x86_64, it can be disabled by setting
> > debug.show_unhandled_signals sysctl variable to 0 (or by doing
> > echo 0 > /proc/sys/debug/show_unhandled_signals)
>
> Do we really need the ratelimiting?  If the admin turns this on then he's
> presumably prepared for the consequences.
>
> I guess "yes", as people (even distros) are likely to turn this on and
> forget about it.
>
> The patch is larger than I expected, ho hum.
>

So, we happy? What else I can chop from this patch to make it more
acceptable for the people involved?
Please be advised that with this patch, the old exception_trace that
was enabled becomes disabled by default; x86_64 had that enabled, and
i386 didn't have anything...
cheers,
Masoud
