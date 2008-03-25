Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbYCYSX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbYCYSX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 14:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYCYSXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 14:23:19 -0400
Received: from qb-out-0506.google.com ([72.14.204.234]:41229 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbYCYSXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:23:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ec32GwsXNTAF+j5SmYJU/P8QU1FoxGXpI3Ma2cDJ/GaF8imtKAkLWwIIDFnRafIZTYsNpGrtVE8W+ejcGZ7aMWfc7AMtoUAN5cgo2TTNDGcfV357trR4R0EXUEjDpagHbV84pBtoy3BhC3btOqXJjJXF5zYv9/+V/u0iI4Agpt4=
Message-ID: <4d8e3fd30803251123t26d562d4v210192bce657ec6a@mail.gmail.com>
Date: Tue, 25 Mar 2008 18:53:15 +0030
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups - formatting only
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
       "David Miller" <davem@davemloft.net>, jirislaby@gmail.com,
       viro@zeniv.linux.org.uk, joe@perches.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080325172817.GT2170@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080323085210.GE10722@ZenIV.linux.org.uk>
	 <20080323.032013.79276201.davem@davemloft.net>
	 <47E647AC.1060906@gmail.com>
	 <20080323.051929.267232495.davem@davemloft.net>
	 <20080325104841.GA24211@elte.hu> <87od93gfbj.fsf@basil.nowhere.org>
	 <1206465548.6437.167.camel@lappy>
	 <20080325172817.GT2170@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/25/08, Andi Kleen <andi@firstfloor.org> wrote:
> > > That is an objective (not just random assertation) reason against
> > > doing extensive changes of existing files like Joe's patchkit.
> >
> > Building a single allyesconfig for x86_32 and x86_64 before and after
> > and getting identical binaries is pretty strong.

true, but it's usually simplier to just compile the affected file.

> checkpatch does not necessarily result in the same binaries. First
> there is the build date and then there might be changes like
> KERN_* prefixes added etc.
>
> And there might be code which is not covered under a single configuration,
> e.g. when both 32bit and 64bit x86 is changed.

in the last series of coding style patches i sent to both ingo and
bart i worked as follow:
- worked on files with agreement of the maintainer (or after he asked
me to do the cleanup)
- separated changes that modified the binary from the pure style changes.
-all the patch were compile tested and when possible a size/md5sum
verificatio was performed and added to the changelog.

i learned this "rules" learning from my mistakes and in the end it
worked well so i think the problem is in how people are using the
tool, not in the tool itself.

ciao,
--
Paolo
http://paolo.ciarrocchi.googlepages.com/
