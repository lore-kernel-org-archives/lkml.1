Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbZIZPrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbZIZPrX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 11:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbZIZPrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 11:47:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbZIZPrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 11:47:22 -0400
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL v2] bkl tracepoints + filter regex support
References: <1253821775-8618-1-git-send-email-fweisbec@gmail.com>
	<20090924201509.GA26573@elte.hu> <20090924201622.GA15459@elte.hu>
	<1253824200.18939.173.camel@laptop> <20090924204357.GB8662@nowhere>
	<1253825489.18939.180.camel@laptop> <20090924213631.GA2661@nowhere>
	<1253866792.10287.0.camel@twins> <20090925091229.GB4686@nowhere>
	<1253871601.10287.23.camel@twins> <20090925103806.GA6467@nowhere>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Sat, 26 Sep 2009 11:47:06 -0400
In-Reply-To: <20090925103806.GA6467@nowhere> (Frederic Weisbecker's message of "Fri, 25 Sep 2009 12:38:07 +0200")
Message-ID: <y0mljk1lnd1.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi -


Frederic Weisbecker <fweisbec@gmail.com> writes:

>> > That said, the future plans have evolved, and I'm fine if you have
>> > changed your opinion and think about a better way to develop this.

>> No, but the thing is, IF we're going to freeze this into ABI, then
>> there's no second chances.

> Right. Once it becomes an ioctl, it becomes an ABI :-/

Are y'all convinced that a little ascii language parser/interpreter is
the right thing to put into the kernel, as opposed to bytecode (with a
userspace compiler)?

- FChE
