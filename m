Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbZAEJiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbZAEJiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbZAEJhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:37:55 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:36364 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbZAEJhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:37:55 -0500
Date: Mon, 5 Jan 2009 10:39:31 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090105093931.GA17944@uranus.ravnborg.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090105090239.GB17530@uranus.ravnborg.org> <20090105011202.835e75ec.akpm@linux-foundation.org> <20090105.011733.225349838.davem@davemloft.net> <20090105092110.GA11941@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105092110.GA11941@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 10:21:10AM +0100, Ingo Molnar wrote:
> 
> * David Miller <davem@davemloft.net> wrote:
> 
> > From: Andrew Morton <akpm@linux-foundation.org>
> > Date: Mon, 5 Jan 2009 01:12:02 -0800
> > 
> > > On Mon, 5 Jan 2009 10:02:39 +0100 Sam Ravnborg <sam@ravnborg.org> wrote:
> > > 
> > > > Hi Andrew.
> > > > 
> > > > > sparc64-use-unsigned-long-long-for-u64.patch
> > > > > sparc64-fix-unsigned-long-long-warnings-in-drivers.patch
> > > > 
> > > > Please drop these two.
> > > 
> > > Might, if they break my build.
> > 
> > They don't build, I tested them when I tried integrated Sam's patches.
> 
> do they break due to some warnings caught by -Werror?

Yup.
In my setup I did not see the warnings.
Most likely because I'm sitting on an older i386 and the
64 bit version of gcc emits more warnings than my 32 bit version.

The build broke in with Dave's native gcc and will most likely with
a 64 bit cross compiler too.

I do not want to remove the -Werror just due to this as it
is only a limited effort to fix up the patches when I get
my setup fixed.

But due to other issues (you know work and such) it it not the next week
that I have a proper setup.

	Sam
