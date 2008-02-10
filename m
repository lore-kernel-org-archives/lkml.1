Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbYBJKGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbYBJKGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 05:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757217AbYBJKGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 05:06:03 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:50102 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbYBJKGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 05:06:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MPekuahPuuv3kaf6SexHSIGuC9QWuVprIjW0ZC7e37F0ER5SLowlplzBWOlnZU6NLfWjWcVRpCNlMw1skmpsuzJWjDJAmV8pKiTN+b6ZVN/Ewsw/C4QVQGDFk3nJHWwOgty/kcLU/Rirq84VptIBaSHP/sstIev6f+dh3zZgekk=
Message-ID: <8bd0f97a0802100206n7b79cd0es4d79409678880a34@mail.gmail.com>
Date: Sun, 10 Feb 2008 05:06:00 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: schwidefsky@de.ibm.com
Subject: Re: CONFIG_HIGHPTE vs. sub-page page tables.
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1202636468.21652.26.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802081902.m18J2nOm005840@hera.kernel.org>
	 <20080208230433.GA8524@elte.hu> <20080208231506.GA13350@elte.hu>
	 <1202551589.8936.1.camel@localhost> <20080209103728.GA29375@elte.hu>
	 <1202554574.8936.15.camel@localhost>
	 <8bd0f97a0802090956r2de999fap7f16e173858be240@mail.gmail.com>
	 <1202635061.21652.8.camel@localhost>
	 <8bd0f97a0802100125va445d5ci81122da279b80d5f@mail.gmail.com>
	 <1202636468.21652.26.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 10, 2008 4:41 AM, Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> On Sun, 2008-02-10 at 04:25 -0500, Mike Frysinger wrote:
> > i guess my point was more: the pgtable_t typdef is new therefore it
> > must be defined for every architecture.  your ability to directly
> > cross-compile and/or test a subset is great, but posting a change that
> > is know for a fact to break arches you didnt update seems like a bad
> > idea.  even if you just included the obvious-but-not-compile-tested
> > changes and included the linux-arch@vger alias instead would have been
> > better than nothing
>
> The patch was posted multiple times on linux-arch and it has been part
> of -mm for 3 months. Plenty of time for the arch maintainers to notice.
> And without the pte_pfn_t change it would compile on a nommu
> architecture even without the typedef. That is why I didn't add the new
> typedef to the nommu archs.

generally things are posted to linux-arch for the arch maintainers to
review.  the person posting the changes does all the footwork to make
sure no one is left behind since they're the ones proposing the
change.  it isnt "hey, unless you do something, your arch is going to
be broken, sorry".

> Which turned out to be a mistake after the
> pte_pfn_t change has been added but the problem is fixed with the patch
> sent yesterday, isn't?

yes, the patch you posted for the remaining arches should fix the
arches left broken.
-mike
