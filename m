Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbZAFO2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbZAFO2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 09:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbZAFO2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 09:28:15 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:45682 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbZAFO2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 09:28:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=C/8b8kHWfcknrnjEvBRhTPEH1E2fE1CDBSHKxg7obwDE+5g7UUzKf2QmHtI0oiMega
         ClWQlvvWLklY0ViziNzBQSAQmwBcb6DA+i+OMRA0bA+7hb8pJM575BhWo0Sfrkre8iNa
         6XPu+UZw1PFldsbsDzKoy/K38dO546Wgo9mxM=
Message-ID: <3f9a31f40901060628t3bffe020v6e70c5d6cf17f51e@mail.gmail.com>
Date: Tue, 6 Jan 2009 19:58:13 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 04/11] x86: cleanup remaining cpumask_t ops in smpboot code
Cc: "Jaswinder Singh Rajput" <jaswinder@infradead.org>,
       "Ingo Molnar" <mingo@redhat.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jack Steiner" <steiner@sgi.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4963645A.1040201@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231222512.3235.6.camel@jaswinder.satnam>
	 <1231223480.3235.22.camel@jaswinder.satnam> <4963645A.1040201@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Tue, Jan 6, 2009 at 7:32 PM, Mike Travis <travis@sgi.com> wrote:
>
> I'll look closer but I had assumed that these masks would not be
> used for UP configurations (it did not get any compile errors
> with the allnoconfig).  In fact, any access to these masks for
> UP would be unnecessary since there are no callouts, the boot
> cpu is assumed initialized, and it has no siblings.  So the
> masks are specific to SMP.
>

If it is specific to SMP then:
CONFIG_X86_64 should be CONFIG_X86_64_SMP
CONFIG_X86_32 should be CONFIG_X86_32_SMP

I am in the process of cleaning smp.h and moving out non-smp from
smp.h as per Ingo's suggestion.

I am planning to move cpumask related things to asm/cpumask.h

Is this OK to you.

--
JSR
