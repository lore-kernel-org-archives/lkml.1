Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbYHJTZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbYHJTZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 15:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYHJTZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 15:25:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:29455 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbYHJTZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 15:25:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mW/8iljfLgG77Ir3DFmthRZpxXt+IK1UhtDMotS+CiGxDG2ViRryXsg1nW4wqZDs6e
         +U32ntTWWUCR07xsLeKiFrHw5GAvkjJ4ipErHoYgI74CrZqf0ji71Jm7qP0bejD+wZJt
         gfe348250DNfqCEcoK2Nq979E2v/d21AREjMg=
Date: Sun, 10 Aug 2008 21:24:49 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-pm@lists.linux-foundation.org
Subject: Re: resume from s2ram regression (bisected to ftrace...)
Message-ID: <20080810192444.GA5296@joi>
References: <20080810170801.GA5739@joi> <200808101940.13753.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808101940.13753.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 07:40:12PM +0200, Rafael J. Wysocki wrote:
> On Sunday, 10 of August 2008, Marcin Slusarz wrote:
> > Hi
> > 
> > Few days ago I discovered that resume from suspend to ram does not work anymore
> > on my 2.6.27-rc2 (actually 796aadeb1b2db9b5d463946766c5bbfd7717158c) gentoo box.
> > My computer just boots on resume. Today I had enough time to bisect it and found
> > (after 1 panic and 1 build breakage) out "the reason":
> > 
> > $ git bisect good
> > d05cdb25d80f06f77aa6bddb53cd1390d4d91a0b is first bad commit
> > commit d05cdb25d80f06f77aa6bddb53cd1390d4d91a0b
> > Author: Steven Rostedt <rostedt@goodmis.org>
> > Date:   Mon May 12 21:20:54 2008 +0200
> > 
> >     ftrace: fix dynamic ftrace selftest
> 
> Does it still happen if:
> - CONFIG_FTRACE is unset

no

> - CONFIG_FTRACE is set, but CONFIG_FTRACE_STARTUP_TEST is unset?

yes

Marcin
