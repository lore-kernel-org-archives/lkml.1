Return-Path: <linux-kernel-owner+w=401wt.eu-S1751246AbZHRSwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbZHRSwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 14:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbZHRSwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 14:52:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36296 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbZHRSwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 14:52:45 -0400
Date: Tue, 18 Aug 2009 14:52:42 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Zhaolei <zhaolei@cn.fujitsu.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Re: [RFC PATCH] Add timer-source of walltime for ftrace
In-Reply-To: <4A8A0D5E.1010805@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0908181452130.727@gandalf.stny.rr.com>
References: <4A698F90.90501@cn.fujitsu.com> <alpine.DEB.2.00.0907240902030.17438@gandalf.stny.rr.com> <20090728103227.D7FB.A69D9226@jp.fujitsu.com> <20090728015351.GF5147@nowhere> <alpine.DEB.2.00.0907272218480.30108@gandalf.stny.rr.com> <4A89213C.5090109@cn.fujitsu.com>
 <20090817164909.GB4953@nowhere> <4A8A0D5E.1010805@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Aug 2009, Zhaolei wrote:

> 
> or make option like:
> # echo wallclock > option/clock
> # echo localclock > option/clock
> is best way.
> But it needs rewriting whole option source.
> 
> Maybe now, we can use a neutrality way as:
> # echo 0 > option/wallclock  # reset to default clock(local clock)
> # echo 0 > option/locakclock # no effect

Or we move it out of options and make it add a "clock_source" file. or 
something?

-- Steve

