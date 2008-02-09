Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbYBIR4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbYBIR4d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYBIR4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:56:25 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:23064 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbYBIR4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:56:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=miQ1XY6qunDKQ52W3YHNoRPnyjE5lSQXsAab3DsQ7zztyIxTQAigXJJ/Qs6SNlP4vHh1Ewu7Z3Ie3UIjoEI30coko7o3nWasWtLKUmYYYCKhvU+qcR4gWr25vH1HL2ARzCvoaO0Vpb9PR0vQs1VqAPArrlfiiP8G4iiEBRa0slk=
Message-ID: <8bd0f97a0802090956r2de999fap7f16e173858be240@mail.gmail.com>
Date: Sat, 9 Feb 2008 12:56:23 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: schwidefsky@de.ibm.com
Subject: Re: CONFIG_HIGHPTE vs. sub-page page tables.
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1202554574.8936.15.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802081902.m18J2nOm005840@hera.kernel.org>
	 <20080208230433.GA8524@elte.hu> <20080208231506.GA13350@elte.hu>
	 <1202551589.8936.1.camel@localhost> <20080209103728.GA29375@elte.hu>
	 <1202554574.8936.15.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 9, 2008 5:56 AM, Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> On Sat, 2008-02-09 at 11:37 +0100, Ingo Molnar wrote:
> > i think the worst is over already and i'm reasonably sure that there are
> > no more bugs in it - this _is_ a 1:1 patch after all, so in theory the
> > worst side-effect should be build breakages due to include file
> > spaghetti. The window for this particular breakage was just 256 commits,
> > that's OK i think.
>
> Except for the breakage of all nommu architectures .. they need the
> pgtable_t as well due to the pte_fn_t type.

so why wasnt this in the original patch ?  why do no-mmu arches have
to add the pgtable_t typedefs themselves ?
-mike
