Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbYJ2BLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbYJ2BLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 21:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYJ2BLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 21:11:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54441 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbYJ2BLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 21:11:22 -0400
Date: Tue, 28 Oct 2008 21:11:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace: fix current_tracer error return
In-Reply-To: <c62985530810281809y115198e1o34800e80c691c302@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0810282111000.26466@gandalf.stny.rr.com>
References: <c62985530810271618n11a8b674w5a60deaa335fdcc2@mail.gmail.com>  <c62985530810271644y1df6a13xbcd9d89b7a17ad75@mail.gmail.com>  <c62985530810280202r694a23e8l5233d892b3aa4330@mail.gmail.com>  <alpine.DEB.1.10.0810281039130.29482@gandalf.stny.rr.com>
  <c62985530810280835k66d3ab87qd1783a0135228174@mail.gmail.com>  <alpine.DEB.1.10.0810281140420.30971@gandalf.stny.rr.com>  <c62985530810281115n5e40539ek1a486a0b909e339c@mail.gmail.com>  <alpine.DEB.1.10.0810281429170.15590@gandalf.stny.rr.com> 
 <c62985530810281734k578f1c2dka79ad045abb8bb93@mail.gmail.com>  <alpine.DEB.1.10.0810282052300.26466@gandalf.stny.rr.com> <c62985530810281809y115198e1o34800e80c691c302@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 29 Oct 2008, Fr?d?ric Weisbecker wrote:
> >> Thanks. I guess this bug was there for several days. But since I
> >
> > But this was not a bug :-/
> >
> > I believe I purposely set it that way. The bug was that you did not know
> > that you could enable it with /proc/sys/kernel/ftrace_enabled ;-)
> 
> Ah ok. I better understand now.
> But IMHO I guess that would better for developpers who will use
> it to have something directly enabled whithout touching this file at each start.

Yep, and that's why I have no objections with the patch ;-)

-- Steve

