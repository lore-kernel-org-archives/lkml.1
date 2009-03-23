Return-Path: <linux-kernel-owner+w=401wt.eu-S1760883AbZCWVOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760883AbZCWVOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 17:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758390AbZCWVOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 17:14:22 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:39036 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230AbZCWVOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 17:14:22 -0400
Date: Mon, 23 Mar 2009 22:16:21 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: cleanup patches 20090322
Message-ID: <20090323211621.GA15364@uranus.ravnborg.org>
References: <1237755176.5417.16.camel@ht.satnam> <200903231845.05394.rusty@rustcorp.com.au> <1237801506.2485.7.camel@ht.satnam> <200903240740.03281.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903240740.03281.rusty@rustcorp.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 07:40:02AM +1030, Rusty Russell wrote:
> On Monday 23 March 2009 20:15:06 Jaswinder Singh Rajput wrote:
> > On Mon, 2009-03-23 at 18:45 +1030, Rusty Russell wrote:
> > > On Monday 23 March 2009 07:22:56 Jaswinder Singh Rajput wrote:
> > > >       x86: e820.h fix various signedness issues in setup.c and e820.c
> > > 
> > > Wouldn't fixing the users be better than changing the header?  Esp. since
> > > it could well now cause similar warnings in userspace programs.
> ...
> > Is this OK, or should I go more further:
> > 
> > From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > Date: Mon, 23 Mar 2009 02:13:01 +0530
> > Subject: [PATCH] x86: e820 fix various signedness issues in setup.c and e820.c
> > 
> > Impact: cleanup
> > 
> > This fixed various signedness issues in setup.c and e820.c:
> > arch/x86/kernel/setup.c:455:53: warning: incorrect type in argument 3 (different signedness)
> 
> This looks fine (assuming it fixes the warnings).
> 
> In future it would be nice to explicitly mention that these are "sparse"
> warnings, not actual "signedness issues" ("Impact: cleanup" implies that,
> but the subject makes it sound like there's a pressing problem).

As long as this goes into the body of the changelog - yes.
We do not want those overly long subject lines.

	Sam
