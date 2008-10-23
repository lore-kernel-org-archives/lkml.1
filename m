Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbYJWQvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbYJWQvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbYJWQvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:51:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39631 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbYJWQvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:51:07 -0400
Date: Thu, 23 Oct 2008 12:51:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Jan Kiszka <jan.kiszka@siemens.com>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 08/13 v2] ftrace: do not trace init sections
In-Reply-To: <20081023164032.GA19070@elte.hu>
Message-ID: <alpine.DEB.1.10.0810231250380.1765@gandalf.stny.rr.com>
References: <20081022212721.167005680@goodmis.org> <20081022213552.440512191@goodmis.org> <49005CD0.2070807@siemens.com> <alpine.DEB.1.10.0810230732100.31839@gandalf.stny.rr.com> <49008A9B.8040905@siemens.com> <alpine.DEB.1.10.0810231202310.1765@gandalf.stny.rr.com>
 <20081023164032.GA19070@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 23 Oct 2008, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > The ftrace buffer can be dumped out on oops. I'm not sure if it is 
> > always on. If it is, I need to make it default off and add a command 
> > line and sysctl to turn it on. Otherwise, we will have people 
> > complaining about the extra output to the console on oops.
> 
> it dumps currently if a tracer is enabled. I saw it a couple of times 
> already during crashes.

That's right. I owe you a patch. I'll write one up.

-- Steve

