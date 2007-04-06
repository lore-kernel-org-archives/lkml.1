Return-Path: <linux-kernel-owner+w=401wt.eu-S932649AbXDFJH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbXDFJH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 05:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932658AbXDFJH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 05:07:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:58863 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932649AbXDFJH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 05:07:56 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18VatVJUdYVMtSkczP4kPfiqrPnQwOp5s8xzCfAz2
	+UA+1d6rr3yIbo
Subject: Re: Ten percent test
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <200704061103.34489.kernel@kolivas.org>
References: <200703290237.38777.kernel@kolivas.org>
	 <1175770950.6609.16.camel@Homer.simpson.net>
	 <20070405115447.GA24138@elte.hu>  <200704061103.34489.kernel@kolivas.org>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 11:07:51 +0200
Message-Id: <1175850471.22272.8.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-06 at 11:03 +1000, Con Kolivas wrote:
> On Thursday 05 April 2007 21:54, Ingo Molnar wrote:
> >  - fiftyp.c:  noticeable, but alot better than previously!
> 
> fiftyp.c seems to have been stumbled across by accident as having an effect 
> when Xenofon was trying to recreate Mike's 50% x 3 test case. I suggest a ten 
> percent version like the following would be more useful as a test for the 
> harmful effect discovered in fiftyp.c. (/me throws in obligatory code style 
> change).
> 
> Starts 15 processes that sleep ten times longer than they run. Change forks to 
> 15 times the number of cpus you have and it should work on any size hardware.

I was more focused on the general case, but all I should have to do to
de-claw all of these sleep exploits is account rr time (only a couple of
lines, done and building now).  It's only a couple of lines.

	-Mike

