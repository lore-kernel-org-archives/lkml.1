Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbZFRDww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbZFRDww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 23:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757618AbZFRDwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 23:52:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52702 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbZFRDwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 23:52:33 -0400
Date: Wed, 17 Jun 2009 23:52:27 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jake Edge <jake@lwn.net>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: problem with function_graph self-test?
In-Reply-To: <20090617214303.483fe0a0@chukar>
Message-ID: <alpine.DEB.2.00.0906172350540.6890@gandalf.stny.rr.com>
References: <20090616122603.6a628097@chukar> <alpine.DEB.2.00.0906172312450.6890@gandalf.stny.rr.com> <20090617214303.483fe0a0@chukar>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 17 Jun 2009, Jake Edge wrote:

> On Wed, 17 Jun 2009 23:24:18 -0400 (EDT) Steven Rostedt wrote:
> 
> > Jake, when you find a bug, you really find a bug!
> 
> heh, glad to be of service :)
> 
> > This is something that gcc is screwing with us. After spending all
> > day today trying to figure out what is happening, I finally found it
> > in the assembly.
> 
> is there something specific to my config that causes this to happen?  I
> assume other folks are running the function_graph selftest under other,
> quite possibly more sane, configs without running into it ... or is it
> just something that most folks aren't running (i can't remember why i
> turned ftrace selftests on, other than, perhaps, general curiosity) ...
> 
> you don't run into this under your "normal" configs?

I don't think it has anything to do with the config, it looks to be some 
functions may do this wacky thing with the stack. If it does, and is 
executed, then it will crash like this.

I think it has more to do with the latest gcc. I tried an older gcc and it 
did not cause this issue.

-- Steve

