Return-Path: <linux-kernel-owner+w=401wt.eu-S965650AbXCMJdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965650AbXCMJdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965656AbXCMJdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:33:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:46971 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965650AbXCMJdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:33:20 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19MaNlXigRMOIs7OSWy65vU8f9VZmtyzDk1hMc6xi
	zxRhEhgokeDOJg
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070313081805.GA22327@elte.hu>
References: <200703111457.17624.kernel@kolivas.org>
	 <200703130549.47058.kernel@kolivas.org>
	 <1173730314.6431.30.camel@Homer.simpson.net>
	 <200703130738.19034.kernel@kolivas.org>
	 <1173732344.6431.54.camel@Homer.simpson.net>
	 <8cd998d50703121551u44ea3d85g2541503373f461f4@mail.gmail.com>
	 <1173762639.7944.45.camel@Homer.simpson.net>
	 <20070313081805.GA22327@elte.hu>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 10:33:18 +0100
Message-Id: <1173778398.6810.21.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 09:18 +0100, Ingo Molnar wrote:

> Con, we want RSDL to /improve/ interactivity. Having new scheduler 
> interactivity logic that behaves /worse/ in the presence of CPU hogs, 
> which CPU hogs are even reniced to +5, than the current interactivity 
> code, is i think a non-starter. Could you try to fix this, please? Good 
> interactivity in the presence of CPU hogs (be them default nice level or 
> nice +5) is _the_ most important scheduler interactivity metric. 
> Anything else is really secondary.

I just retested with the encoders at nice 0, and the x/gforce combo is
terrible.  Funny thing though, x/gforce isn't as badly affected with a
kernel build.  Any build is quite noticable, but even at -j8, the effect
doen't seem to be (very brief test warning applies) as bad as with only
the two encoders running.  That seems quite odd.

	-Mike

