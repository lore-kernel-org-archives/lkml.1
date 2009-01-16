Return-Path: <linux-kernel-owner+w=401wt.eu-S932149AbZAPPyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbZAPPyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 10:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764304AbZAPPxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 10:53:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40883 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764203AbZAPPxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 10:53:44 -0500
Date: Fri, 16 Jan 2009 10:53:42 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/2] ftrace: updates to tip
In-Reply-To: <20090116152103.GA28643@elte.hu>
Message-ID: <alpine.DEB.1.10.0901161050470.22303@gandalf.stny.rr.com>
References: <20090116004050.273665842@goodmis.org> <20090116112345.GC20082@elte.hu> <alpine.DEB.1.10.0901160929300.22303@gandalf.stny.rr.com> <20090116152103.GA28643@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 16 Jan 2009, Ingo Molnar wrote:
> > 
> > But I do notice that not all functions produce a valid stack trace. 
> > Maybe it would be better to add that api :-?
> 
> yes - i think that API would be more intuitive, and that way people could 
> mix more interesting functions (with stack traces) with less important 
> functions (no stack traces).

Ah, that's the point. We can't mix and match on these. Either all 
functions that are traced do the stack trace, or none do. This is where 
the new api may be confusing.  We can register a function to be traced via 
the function pointer, and we can pick which functions to trace, but we can 
not separate out different functions for different traces.

-- Steve

