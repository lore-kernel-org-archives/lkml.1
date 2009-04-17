Return-Path: <linux-kernel-owner+w=401wt.eu-S1761637AbZDQRhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761637AbZDQRhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 13:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbZDQRhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 13:37:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64204 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbZDQRhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 13:37:00 -0400
Date: Fri, 17 Apr 2009 13:36:58 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/lockdep: turn lock->name into an array
In-Reply-To: <1239989260.23397.4848.camel@laptop>
Message-ID: <alpine.DEB.2.00.0904171336030.14919@gandalf.stny.rr.com>
References: <1239662166-13208-1-git-send-email-fweisbec@gmail.com>  <20090414153035.C662.A69D9226@jp.fujitsu.com>  <20090414065303.GA24626@elte.hu>  <49E8BB98.3090901@goop.org> <1239989260.23397.4848.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Apr 2009, Peter Zijlstra wrote:

> On Fri, 2009-04-17 at 10:25 -0700, Jeremy Fitzhardinge wrote:
> > Ingo Molnar wrote:
> > > We could zap all pending trace entries on module unload (it is a 
> > > rare operation)
> > 
> > ....Unless you're trying to trace something across a module unload.  I 
> > don't know if its at all practical, but it would be nice to just zap the 
> > pointers within the buffer, rather than the whole buffer.
> 
> I think the new __string() thing that's in the works will avoid the
> whole problem by copying the string into the buffer, instead of keeping
> a reference.

Speaking of which. We have not heard back from Frederic on this yet. I 
hope he's taking a break, enjoying the sun, and not stuck on some tricky 
macro crap ;-)

-- Steve

