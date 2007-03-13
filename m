Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbXCMGLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbXCMGLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 02:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbXCMGLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 02:11:03 -0400
Received: from mail.gmx.net ([213.165.64.20]:46551 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753139AbXCMGLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 02:11:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+bne1WLi2b7dRi4AeUeMVYWqQUzZk4y6pzLCVePK
	oaSECF36eVO2u+
Subject: Re: [ck] Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for
	2.6.21-rc3-mm2
From: Mike Galbraith <efault@gmx.de>
To: michael chang <thenewme91@gmail.com>
Cc: Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <b14e81f00703121438q6cdaffd0vdb08e0386961f057@mail.gmail.com>
References: <200703111457.17624.kernel@kolivas.org>
	 <200703130549.47058.kernel@kolivas.org>
	 <1173730314.6431.30.camel@Homer.simpson.net>
	 <200703130738.19034.kernel@kolivas.org>
	 <b14e81f00703121438q6cdaffd0vdb08e0386961f057@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 07:08:27 +0100
Message-Id: <1173766107.7944.76.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 17:38 -0400, michael chang wrote:

> Perhaps, Mike Galbraith, do you feel that it should be possible to use
> the CPU at 100% for some task and still maintain excellent
> interactivity?

Within reason, yes.  Defining "reason" is difficult.  As we speak, this
is possible to a much greater degree than with RSDL.  Before anybody
pipes in, yes, I'm very much aware of the down side of the interactivity
estimator, I've waged bloody battles with it, and have the t-shirt :)

> That said, I haven't run the test case in particular yet, although I
> will see if I can get the time to do so soon. In any case, I
> personally do have a few qualms about this test case being run on HT
> virtual cores:

Virtual or physical cores has nothing to do with the interactivity
regression I noticed.  Two nice 0 tasks which combined used 50% of my
box can no longer share that box with two nice 5 tasks and receive the
50% they need to perform.  That's it. From there, we wandered off into a
discussion on the relative merit and pitfalls of fairness.

	-Mike

