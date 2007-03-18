Return-Path: <linux-kernel-owner+w=401wt.eu-S1753084AbXCRGhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbXCRGhH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 02:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbXCRGhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 02:37:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:54873 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753084AbXCRGhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 02:37:05 -0400
X-Provags-ID: V01U2FsdGVkX18zm9Zueiwzw/ObLvz7i3MdG7P2r1oxMr4Cs/Gjus
	Ykc210phfhLVuJ
Subject: Re: is RSDL an "unfair" scheduler too?
From: Mike Galbraith <efault@gmx.de>
To: Bill Huey <billh@gnuppy.monkey.org>
Cc: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>, Avi Kivity <avi@argo.co.il>,
       Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070318060949.GA13583@gnuppy.monkey.org>
References: <200703042335.26785.a1426z@gawab.com>
	 <20070317074506.GA13685@elte.hu> <87fy84i7nn.fsf@depni.sinp.msu.ru>
	 <200703172048.46267.kernel@kolivas.org> <20070317114903.GA20673@elte.hu>
	 <45FC525D.5000708@argo.co.il> <20070318012533.GB2986@holomorphy.com>
	 <Pine.LNX.4.64.0703171830130.4964@woody.linux-foundation.org>
	 <20070318052439.GT943@1wt.eu>  <20070318060949.GA13583@gnuppy.monkey.org>
Content-Type: text/plain
Date: Sun, 18 Mar 2007 07:37:02 +0100
Message-Id: <1174199822.8543.5.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-17 at 23:09 -0700, Bill Huey wrote:

> Like I've said in a previous email, SGI schedulers have an interactive
> term in addition to the normal "nice" values. If RSDL ends up being too
> rigid for desktop use, then this might be a good idea to explore in
> addition to priority manipulation.

I've done that already (ain't perfect yet, maybe never be).  The hard
part is making it automatic, and not ruining the good side of RSDL in
the process.

	-Mike

