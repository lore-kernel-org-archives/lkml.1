Return-Path: <linux-kernel-owner+w=401wt.eu-S1751107AbZJTHtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107AbZJTHtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 03:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbZJTHtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 03:49:14 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:37395 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbZJTHtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 03:49:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JWC5VTWBJcnvkt7eS4sE4/2MRE91wsWYhiWwtKm9kqF8NbDe74Tbt/DHaJLLeIQm/T
         aMF22B1p7+ks0x6oM3kQK42mvyGF/leLRcbJ2nHeJ3/wFYVeOfEYsVGPC3AGzDRzRw0d
         uyC50r3v3C9O5+K87/l1yY1rb04nA96B8RYsw=
Date: Tue, 20 Oct 2009 09:49:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: hw-breakpoints: Actually flush thread
	breakpoints in flush_thread().
Message-ID: <20091020074908.GA4939@nowhere>
References: <20091005102306.GA7889@linux-sh.org> <20091005104955.GA14852@in.ibm.com> <20091009034003.GA7747@linux-sh.org> <20091017234250.GC10344@nowhere> <20091018062558.GA20535@linux-sh.org> <20091019194842.GD4880@nowhere> <20091019232431.GB18597@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019232431.GB18597@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 08:24:32AM +0900, Paul Mundt wrote:
> > Oh you have based SH breakpoint support on top of the current breakpoint
> > API in -tip?
> > 
> > Hm, you should have talked to us about that since it's being reworked.
> > 
> Strange, I thought that's what I was doing ;-)
[...]
> I wanted to get the initial support out of the way early to see if there
> was anything in the generic code that needed work, but apart from some
> minor stuff it's been kept fairly well isolated. The SH support I have
> works fine, but isn't a lot of code, and can trivially be reworked on top
> of whatever the new interface looks like. I've left out things like
> ptrace and kgdb stub integration precisely because I knew the code was
> being reworked.
> 
> Given that, I'm not in any particular rush, so whenever the reworked
> patches are available, I'll give them a run and rebase accordingly.


Ah ok. I was just worrying you thought the current state is stable.
Ok, no problem then, Thanks. :)

