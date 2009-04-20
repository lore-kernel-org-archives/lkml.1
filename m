Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbZDTTYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbZDTTYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 15:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZDTTYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 15:24:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41389 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbZDTTYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 15:24:01 -0400
Date: Mon, 20 Apr 2009 15:23:58 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, mingo@goodmis.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC] Stupid tracepoint ideas
In-Reply-To: <20090420191755.GA15571@elte.hu>
Message-ID: <alpine.DEB.2.00.0904201520590.26147@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0904201456470.26147@gandalf.stny.rr.com> <20090420191755.GA15571@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 20 Apr 2009, Ingo Molnar wrote:
> 
> does this boot fine? If yes then it would be nice to have a 
> measurement.

Currently, it locks up in the kmem part of the event tracer self test. But 
I'm not sure if it is due to this or if I uncovered another bug. It 
consistantly locks up in the same place too. But looking at the objdump, I 
don't see anything wrong.

/me still investigating.

-- Steve

