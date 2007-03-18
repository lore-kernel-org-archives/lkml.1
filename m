Return-Path: <linux-kernel-owner+w=401wt.eu-S1752965AbXCRBc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbXCRBc6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 21:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbXCRBc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 21:32:58 -0400
Received: from smtp.osdl.org ([65.172.181.24]:51950 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbXCRBc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 21:32:57 -0400
Date: Sat, 17 Mar 2007 18:32:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: William Lee Irwin III <wli@holomorphy.com>
cc: Avi Kivity <avi@argo.co.il>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org,
       Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: is RSDL an "unfair" scheduler too?
In-Reply-To: <20070318012533.GB2986@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0703171830130.4964@woody.linux-foundation.org>
References: <200703042335.26785.a1426z@gawab.com> <20070317074506.GA13685@elte.hu>
 <87fy84i7nn.fsf@depni.sinp.msu.ru> <200703172048.46267.kernel@kolivas.org>
 <20070317114903.GA20673@elte.hu> <45FC525D.5000708@argo.co.il>
 <20070318012533.GB2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 17 Mar 2007, William Lee Irwin III wrote:
> 
> One issue this raises is prioritizing users on a system, threads within
> processes, jobs within users, etc.

Doing some "classing" even by just euid might be a good idea. It would 
actually catch X automatically most of the time, because the euid of the X 
server is likely to be root, so even for the "trivial" desktop example, it 
would kind of automatically mean that X would get about 50% of CPU time 
even if you have a hundred user clients, just because that's "fair" by 
euid.

Dunno. I guess a lot of people would like to then manage the classes, 
which would be painful as hell. 

		Linus
