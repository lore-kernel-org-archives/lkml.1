Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbZCWVKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbZCWVKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 17:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbZCWVKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 17:10:08 -0400
Received: from ozlabs.org ([203.10.76.45]:50824 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326AbZCWVKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 17:10:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [git-pull -tip] x86: cleanup patches 20090322
Date: Tue, 24 Mar 2009 07:40:02 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1237755176.5417.16.camel@ht.satnam> <200903231845.05394.rusty@rustcorp.com.au> <1237801506.2485.7.camel@ht.satnam>
In-Reply-To: <1237801506.2485.7.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903240740.03281.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 March 2009 20:15:06 Jaswinder Singh Rajput wrote:
> On Mon, 2009-03-23 at 18:45 +1030, Rusty Russell wrote:
> > On Monday 23 March 2009 07:22:56 Jaswinder Singh Rajput wrote:
> > >       x86: e820.h fix various signedness issues in setup.c and e820.c
> > 
> > Wouldn't fixing the users be better than changing the header?  Esp. since
> > it could well now cause similar warnings in userspace programs.
...
> Is this OK, or should I go more further:
> 
> From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Date: Mon, 23 Mar 2009 02:13:01 +0530
> Subject: [PATCH] x86: e820 fix various signedness issues in setup.c and e820.c
> 
> Impact: cleanup
> 
> This fixed various signedness issues in setup.c and e820.c:
> arch/x86/kernel/setup.c:455:53: warning: incorrect type in argument 3 (different signedness)

This looks fine (assuming it fixes the warnings).

In future it would be nice to explicitly mention that these are "sparse"
warnings, not actual "signedness issues" ("Impact: cleanup" implies that,
but the subject makes it sound like there's a pressing problem).

Thanks,
Rusty.
