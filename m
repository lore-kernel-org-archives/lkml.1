Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbXJDPIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbXJDPIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 11:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756688AbXJDPIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 11:08:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:5254 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbXJDPIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 11:08:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O/32i+8cdO5uCQeQPFQhpK8/HsHgtlGHAr4W0m1vpPmwuV5TcWh8rD4PekhSTq482vzCxKwlalU22hL732sEoyx8KGKa/zGoy61ndw2U6Qephvvb5KO4wQPf1rLdyCu4crJ52J8ibLbFhWTctnYXvnu5HeijagTm223k6qPdRJk=
Message-ID: <b6fcc0a0710040808x56ff97a2o2e7a461f738abd84@mail.gmail.com>
Date: Thu, 4 Oct 2007 19:08:43 +0400
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [bug] crash when reading /proc/mounts (was: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Greg KH" <gregkh@suse.de>, "Alexander Viro" <viro@ftp.linux.org.uk>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20071004141251.GG10852@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
	 <20071003084607.GC32218@elte.hu>
	 <alpine.LFD.0.999.0710030804310.3579@woody.linux-foundation.org>
	 <20071004141251.GG10852@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/4/07, Adrian Bunk <bunk@kernel.org> wrote:
> On Wed, Oct 03, 2007 at 08:11:05AM -0700, Linus Torvalds wrote:
> >...
> > and btw, there is no question what-so-ever about whether your compiler
> > might be doing a legal optimization - the compiler really is wrong, and is
> > total shit. You need to make a gcc bug-report.
> >...
>
> Ingo can't send a gcc bug-report since gcc 4.0 is no longer supported
> upstream and a 4.1.2 compiler was confirmed to work.

Ingo can upgrade to 4.0.4. :-)

> Our only options are to either stop supporting the broken gcc versions
> as compiler for the kernel or to work around this compiler bug in the
> kernel.

Distro can backport a fix for miscompilation while leaving, say,
__GNUC_MINOR__ intact, so banning version numbers aren't terribly
useful.

Perhaps, someone should write a script/test program to check for known
miscompilations. to cure himself from deprecation disease.

    Alexey "make cc_check" Dobriyan
