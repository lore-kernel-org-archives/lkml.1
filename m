Return-Path: <linux-kernel-owner+w=401wt.eu-S1758952AbXHCJ0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbXHCJ0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 05:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757287AbXHCJZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 05:25:57 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:15657 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757195AbXHCJZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 05:25:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TVrh/aKqKx8pcFF2h4aOLIRnYwrz1ThYFnFBeprofQ0fB7p7YIyuf6YVteP9gJ8rfAUcXVbuCNvUXXH6IUxelkEUSax6silWKbK1xcx4h28j7LuqsRKD0mHUSNPPLf8hEpfZISOPMYQ/ZwqSJ/8puuV4MGXwy4F0lqPRRH/1048=
Message-ID: <ef8c225f0708030225m42805f0cn943b38399dfa32a9@mail.gmail.com>
Date: Fri, 3 Aug 2007 14:55:55 +0530
From: "Andev Debi" <andev.debi@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Problem - disabling IRQ #20 and others
Cc: "debian developer" <debiandev@gmail.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, lenb@kernel.org, rl@hellgate.ch,
       "Dave Airlie" <airlied@linux.ie>
In-Reply-To: <20070802113146.30eb2139.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ef8c225f0708010347l2a0a8e4cj4f47a243bba88989@mail.gmail.com>
	 <f24d23310708010711w7cec4718tde8fd33b89fdfcf6@mail.gmail.com>
	 <20070802014819.4760b06a.akpm@linux-foundation.org>
	 <ef8c225f0708020427i6665d486he6a90f1f02823382@mail.gmail.com>
	 <20070802113146.30eb2139.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/3/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 2 Aug 2007 16:57:42 +0530
> "Andev Debi" <andev.debi@gmail.com> wrote:
>
> > On 8/2/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > >> Please fix the wordwrapping before sending any more stuff - it's truly awful.
> > >
> > Sorry about that. Gmail automatically wraps the line. Will check in the future.
> >
> > > Could be a bug in the via driver, but it's more likely an
> > > acpi/pci/platform/bios thing.
> > >
> > CC'ing VIA Rhine network driver maintainer. May be he has any idea.
>
> Sorry, I meant the VIA DRM driver.
>
> > CC'ing ACPI people too.
>
> I suspect that's getting warmer.
>
> > > Did any previous kernels work OK?  If so, which?
> > >
> >
> > I booted with the stock ubuntu kernel 2.6.15-28-386, and it is showing
> > a different irq (irq #201)being disabled.
>
> OK, that's bad.
>
>
> > Im attaching the dmesg of both stock 2.6.15 and self compiled 2.6.22.1-cfs-v19
>
> For long-term bugs like this one it's best to track it in
> bugzilla.kernel.org.  I'd suggest that you assign it to
> acpi_config-interrupts@kernel-bugs.osdl.org and add airlied@linux.ie to the
> cc.
>
> It'll take a while, but these things often do end up fixed.
>
OK, done that.
Bug tracker Number : 8841.
