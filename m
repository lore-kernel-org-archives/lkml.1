Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbXE3WtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbXE3WtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbXE3Ws6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:48:58 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:21840 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbXE3Ws5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:48:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GDRLFv3Y7T3ZUQoCHvFEraEiklhz3+Gq1jEiHn5StGFaaF7Owl5Wosz7QW1+kwZoL0EdcBB6XRhZaynMnxAAtL4dsqswYzOm/YyWCaahspoO5/If5OTR2KG2yQr4cdsZH0r1PUL21SLCECLqg6N7aQOlJBTkJ/4SrJcu98jHZdA=
Message-ID: <a781481a0705301548t6ceaf3f6p8f15959ed69b0432@mail.gmail.com>
Date: Thu, 31 May 2007 04:18:54 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH 1/3] hexdump: more output formatting
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, hugh@veritas.com
In-Reply-To: <465DFE4C.6090503@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	 <20070524145517.1f32cd94.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0705241533510.32401@schroedinger.engr.sgi.com>
	 <20070530143428.2f20446a.randy.dunlap@oracle.com>
	 <a781481a0705301456n246e7185ife2a144eae3179b3@mail.gmail.com>
	 <465DF49B.7040100@oracle.com>
	 <a781481a0705301511p69387b2ep754c8c754ba09f36@mail.gmail.com>
	 <Pine.LNX.4.64.0705301515290.14642@schroedinger.engr.sgi.com>
	 <a781481a0705301541h242d679fhebf314c2f6721901@mail.gmail.com>
	 <465DFE4C.6090503@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/31/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Satyam Sharma wrote:
> > On 5/31/07, Christoph Lameter <clameter@sgi.com> wrote:
> >> On Thu, 31 May 2007, Satyam Sharma wrote:
> >>
> >> > Yes, you're right, but I was just wondering whether any users really
> >> > cared enough about the rowsize and groupsize, also seeing that
> >> > accommodating these two args leads to a lot of increase in code.
> >>
> >> Have two functions
> >>
> >> 1. A function that prints full lines with address and ascii
> >>         This defaults to 16 bytes by default + ascii.
> >>
> >> hex_dump?
> >>
> >> 2. A function to convert a few bytes for use in other output.
> >>
> >> sprint_hex?
> >
> > Yes, or we could go the whole hog and have a total of 4 functions:
> >
> > (1) For users that want to use a short version, and are fine with
> > the default values for the grouping / other parameters -- also have
> > both the print_to_buffer/sprint_hex and print_to_console/hex_dump
> > variants.
> >
> > (2) For users that care about these parameters, both the variants
> > with the expanded arglist (the ones listed above in (1) would then
> > just be inlines wrapping over these ones)
> >
> > Just that it would be nice if there is some simple (with short arglist)
> > function that works well-enough for most people that everyone would
> > be able to adopt/use quickly.
>
> Satyam, you sound like you need something to do, so please grep the
> kernel tree for /hexdump/, /hex_dump/, /dump_hex/, /dumphex/, and
> other such variants and help me add some callers for lib/hexdump.c.
> That way we can see what parameters it really needs.

Sure, I'll get started on this, then! :-)
