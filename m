Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbXIDPFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbXIDPFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 11:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbXIDPFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 11:05:35 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:59765 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbXIDPFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 11:05:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gWWFyZMOMCKcYeFtv1Sl7pa+MyU/h8GzbsFrYmn7RfanRPlTNSbFCeN+IPG6hNjzkZTZCz3fgN2PsDSR2RuKx6KI8LlHUgwglFIkfj+uZ62hhDS1NvHiazGki5F3r4OtkE7EuIQ7SMN+k9xzAzzd5RIy8o3XeLSf7i+cjvJkmSI=
Message-ID: <8bd0f97a0709040805y233cf07yc60ec0fedadb706d@mail.gmail.com>
Date: Tue, 4 Sep 2007 11:05:33 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: the Linux kernel, testsuites, and maybe *you*
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070902154351.GA21230@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0708311422u309ff09cs24dfe64ff535a982@mail.gmail.com>
	 <p733axyxcli.fsf@bingen.suse.de>
	 <8bd0f97a0709011550y833fb5ax7d40cae937789fd8@mail.gmail.com>
	 <20070902065926.GA15487@one.firstfloor.org>
	 <8bd0f97a0709020815r75fcb225lf44bcb57783b436c@mail.gmail.com>
	 <20070902154351.GA21230@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/2/07, Andi Kleen <andi@firstfloor.org> wrote:
> On Sun, Sep 02, 2007 at 11:15:23AM -0400, Mike Frysinger wrote:
> > there is still the ABI issue ... code written in kernel space in pure
> > asm cannot always be compiled in userspace and work properly/the same
>
> Is that a blackfin weirdness?

yes, Blackfin is weird in this respect due to being a no-mmu and
wanting ELF, but i was being sufficiently general to bolster my claims
and to leave the door open for any other port out there i'm not
familiar with and any port that comes along

> > > The other issue to test some of them properly you need unmapped pages
> > > etc. That gets much easier to do in user space. There are some other
> > > issues.
> >
> > you mean testing boundary overflows ?  can be handled with canaries
> > rather than segfaults i imagine ...
>
> Not for reads, no.

true, but generally the string functions arent searching for crashes
in the boundary conditions ... they just happen to sometimes find them
:)
-mike
