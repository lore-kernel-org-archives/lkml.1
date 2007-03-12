Return-Path: <linux-kernel-owner+w=401wt.eu-S965509AbXCLKem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965509AbXCLKem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 06:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965511AbXCLKem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 06:34:42 -0400
Received: from mail30.syd.optusnet.com.au ([211.29.133.193]:55412 "EHLO
	mail30.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965509AbXCLKel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 06:34:41 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Xavier Bestel <xavier.bestel@free.fr>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Date: Mon, 12 Mar 2007 21:34:13 +1100
User-Agent: KMail/1.9.5
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
References: <200703111457.17624.kernel@kolivas.org> <200703122022.43021.kernel@kolivas.org> <1173692319.5835.611.camel@frg-rhel40-em64t-03>
In-Reply-To: <1173692319.5835.611.camel@frg-rhel40-em64t-03>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703122134.13554.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007 20:38, Xavier Bestel wrote:
> On Mon, 2007-03-12 at 20:22 +1100, Con Kolivas wrote:
> > On Monday 12 March 2007 19:55, Mike Galbraith wrote:
> > > Hmm.  So... anything that's client/server is going to suffer horribly
> > > unless niced tasks are niced all the way down to 19?
> >
> > Fortunately most client server models dont usually have mutually
> > exclusive cpu use like this X case. There are many things about X that
> > are still a little (/me tries to think of a relatively neutral term)...
> > wanting. :(
>
> I'd say the problem is less with X than with Xlib, which is heavily
> round-trip-based. Fortunately XCB (its successor) seeks to be more
> asynchronous.

Yes I recall a talk by Keith Packard on Xorg development and how a heck of a 
lot of time spent spinning by X (?Xlib) for no damn good reason was the 
number one thing that made X suck and basically it was silly to try and fix 
that at the cpu scheduler level since it needed to be corrected in X, and was 
being actively addressed. So we should stop trying to write cpu schedulers 
for X.

> 	Xav

-- 
-ck
