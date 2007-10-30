Return-Path: <linux-kernel-owner+w=401wt.eu-S1756390AbXJ3VEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390AbXJ3VEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbXJ3VEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:04:42 -0400
Received: from smtp3.netcabo.pt ([212.113.174.30]:3050 "EHLO
	exch01smtp11.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753533AbXJ3VEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:04:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAJY5J0dViqaH/2dsb2JhbAAMkCc
Message-ID: <47279BF4.4060207@rncbc.org>
Date: Tue, 30 Oct 2007 21:02:44 +0000
From: Rui Nuno Capela <rncbc@rncbc.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: 2.6.23.1-rt5 (was 2.6.23-rt1 trouble)
References: <1192154640.15992.10.camel@localhost.localdomain>          <38542.213.58.131.130.1192445349.squirrel@www.rncbc.org> <471648B8.1030007@rncbc.org> <47234EA1.4050006@rncbc.org> <Pine.LNX.4.58.0710271203170.28617@gandalf.stny.rr.com> <47239A37.8000401@rncbc.org> <472781E3.7010103@rncbc.org> <Pine.LNX.4.58.0710301526480.30690@gandalf.stny.rr.com> <47278BE5.9070401@rncbc.org> <Pine.LNX.4.58.0710301605100.31349@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0710301605100.31349@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Oct 2007 21:04:37.0011 (UTC) FILETIME=[7AA98E30:01C81B38]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> --
>> yes, running without the *cough* nvidia module is under way. but do you
>> remember that on my other laptop the freezes also happen and on that one
>> there's no single proprietary modules in it? (same .config btw) problem
>> is, like most modern laptops, it doesn't come bundled with a serial port
>> so that can't give you a serial console evidence ...
>>
>> thanks for the reminder, anyway ;)
>>
> 
> hmm, it could also be a separate issue. This other laptop is the one that
> took a while to freeze. Correct?
> 

yes, it seems that was the case, but not sure if still applies. the
moment of the freezes are rather random, sometimes in the (tainted)
desktop one it takes a while too before it starts to hiccup.

> Was it only on X apps? Or could it possible be something we could do via a
> command line and then we could see vga output (if any).
> 

most of the time, yes, it's on X applications. if I get into a tty (eg.
via Alt-Ctrl-F1) it seems to eventually recover from the intermitent
frozen state easier, but its just a matter of time to have it also dead
on the console, sooner or later. once it starts freezing the first time
  I know the whole system is, how should i say? doomed ...

never saw a bug, oops or panik message. it just drops dead, until
SysRq-B gets hit in despair :)

cheers
-- 
rncbc aka Rui Nuno Capela
rncbc@rncbc.org
