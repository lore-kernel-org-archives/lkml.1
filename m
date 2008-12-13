Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbYLMO7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbYLMO7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 09:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYLMO7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 09:59:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48854 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYLMO7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 09:59:31 -0500
Date: Sat, 13 Dec 2008 09:59:28 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Cyrill Gorcunov <gorcunov@gmail.com>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [RFC] x86: entry_64 - introduce FTRACE_ frame macro
In-Reply-To: <c62985530812130646r6bcdf424o752f16458dd22914@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0812130956350.17344@gandalf.stny.rr.com>
References: <20081212184136.GB14192@localhost>  <1229113167.32623.12.camel@localhost.localdomain>  <20081212204724.GA26194@localhost>  <alpine.DEB.1.10.0812121552360.19351@gandalf.stny.rr.com>  <20081212205729.GA28554@localhost> 
 <alpine.DEB.1.10.0812121620520.19351@gandalf.stny.rr.com>  <20081212213538.GA731@localhost>  <alpine.DEB.1.10.0812121655090.19351@gandalf.stny.rr.com>  <20081213082054.GA7559@localhost> <c62985530812130646r6bcdf424o752f16458dd22914@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 13 Dec 2008, Fr?d?ric Weisbecker wrote:
> 2008/12/13 Cyrill Gorcunov <gorcunov@gmail.com>:
> Hi,
> 
> Looks good and clarify the asm bits.
> 
> I wonder if the function_graph_tracer should continue to necessarily
> depend on the function tracer.
> It was more simplier to do so but perhaps that could be avoided with
> small modifications.

It could be, but remember, the dynamic ftrace gives the ability to specify 
which function can be chosen.

But on the other hand, I guess it would be fine to have it separate. There 
is no reason that it can not be. I would still keep the dynamic part 
dependent on function tracer. At least for now.

-- Steve

