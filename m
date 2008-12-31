Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbYLaSdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbYLaSdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 13:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbYLaSdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 13:33:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43363 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921AbYLaSdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 13:33:22 -0500
Date: Wed, 31 Dec 2008 13:33:19 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, mingo@elte.hu,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@gmail.com>
Subject: Re: ftrace behaviour (was: [PATCH] ftrace: introduce
 tracing_reset_online_cpus() helper)
In-Reply-To: <20081231155325.392699d0@iki.fi>
Message-ID: <alpine.DEB.1.10.0812311332410.6262@gandalf.stny.rr.com>
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI> <c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com> <alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com> <20081220004453.50aec846@daedalus.pq.iki.fi>
 <alpine.DEB.1.10.0812191827390.26234@gandalf.stny.rr.com> <20081220041759.5a026f5a@daedalus.pq.iki.fi> <alpine.DEB.1.10.0812192140350.29275@gandalf.stny.rr.com> <20081231155325.392699d0@iki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Dec 2008, Pekka Paalanen wrote:
> 
> "tracing_on" is not a function call, so nesting does not make sense.
> It is a file in debugfs, and therefore an end user interface. I am only
> talking about the debugfs files, not functions. Only developers use
> functions and devels can be expected to find the implementation and
> read the fine documentation.
> 
> How about /debug/tracing/recording with values 0 and 1?
> That would be a clear distinction to /debug/tracing/tracing_enabled.
> I have also wondered about the "tracing_" prefix, the files are
> already in the tracing/ directory.
> 
> I am just trying to think what file names would make sense in
> debugfs. I completely agree with you on function naming, but should
> the file have the same name as the function? Sure, for developers
> it would be easier to remember, but the name might not make any
> sense unless you know the internal implementation.
> 
> If something else than tracing starts to use the ring buffer
> facility, we have to think about the names again. Until then,
> just my 2c. :-)

Since this really only enables or disables the ring buffer, perhaps 
"ringbuffer_enabled" is the way to go?

-- Steve

