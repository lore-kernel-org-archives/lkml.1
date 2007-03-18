Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbXCRG0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbXCRG0P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 02:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbXCRG0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 02:26:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:52740 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752844AbXCRG0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 02:26:14 -0400
X-Provags-ID: V01U2FsdGVkX190nzg6M0x0A519Tuesh7IgAyLY11TaSTaIIe2A7a
	AEcohRo7VilUzW
Subject: Re: is RSDL an "unfair" scheduler too?
From: Mike Galbraith <efault@gmx.de>
To: Willy Tarreau <w@1wt.eu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>, Avi Kivity <avi@argo.co.il>,
       Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070318052439.GT943@1wt.eu>
References: <200703042335.26785.a1426z@gawab.com>
	 <20070317074506.GA13685@elte.hu> <87fy84i7nn.fsf@depni.sinp.msu.ru>
	 <200703172048.46267.kernel@kolivas.org> <20070317114903.GA20673@elte.hu>
	 <45FC525D.5000708@argo.co.il> <20070318012533.GB2986@holomorphy.com>
	 <Pine.LNX.4.64.0703171830130.4964@woody.linux-foundation.org>
	 <20070318052439.GT943@1wt.eu>
Content-Type: text/plain
Date: Sun, 18 Mar 2007 07:26:11 +0100
Message-Id: <1174199171.8543.1.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-18 at 06:24 +0100, Willy Tarreau wrote:

> Maybe we're all discussing the problem because we have reached the point
> where we need two types of schedulers : one for the desktop and one for
> the servers. After all, this is already what is proposed with preempt,
> it would make sense provided they share the same core and avoid ifdefs
> or unused structure members. Maybe adding OPTIONAL unfairness to RSDL
> would help some scenarios, but in any case it is important to retain
> the default fairness it provides.

Bingo.

