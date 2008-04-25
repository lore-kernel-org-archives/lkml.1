Return-Path: <linux-kernel-owner+w=401wt.eu-S933365AbYDYXGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbYDYXGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 19:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759471AbYDYXGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 19:06:03 -0400
Received: from anchor-post-30.mail.demon.net ([194.217.242.88]:3541 "EHLO
	anchor-post-30.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933236AbYDYXGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 19:06:01 -0400
From: fox@crisp.demon.co.uk
To: t-nishiie@np.css.fujitsu.com, bart.vanassche@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: RE: dtrace for linux
Date: Sat, 26 Apr 2008 00:05:58 +0100
User-Agent: Demon-WebMail/2.0
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Message-Id: <E1JpWzO-000Ftm-Ot@pr-webmail-2.demon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >> On Sun, Apr 20, 2008 at 1:17 AM,  <fox@crisp.demon.co.uk> wrote:
> >>>
> >>>  I would like to announce that I am working on dtrace for Linux.
> >>>  I have the userland dtrace binary compiled, along with the first
> >>>  pre-pre-alpha dtracedrv.ko module loaded into my kernel.
> >> 
> >> This is great news. How will this dtrace implementation differ from
> >> SystemTap (http://sourceware.org/systemtap/) ?
> >> 
> >> Bart.
> >> 
> >> 
> >
> >Hello Bart,
> >
> >
> >I dont know systemtap all that well, other than what i have
> >read on the net and browsed in the source. systemtap is similar,
> >but dtrace provides a high level functional language (D) and
> >a set of methodologies and scripts which mean learning/training
> >will make it easier to use.
> 
> Hello,
> 
>   SystemTAP is the tool developed in order to do the same thing 
> as Dtrace. When development of SystemTAP started, Dtrace was not
>  able to be used with restriction by the license at linux. The 
> difference in both SystemTAP and Dtrace is produced by avoiding 
> being based on mounting peculiar to linux, and a license.
> 
>   By the way, aren't any ideas found in order to mitigate the 
> load when acquiring trace? If load when having taken trace as 
> for LTTng as for SystemTAP is too heavy, I feel. For example, 
> it is desirable that trace with lighter load can be taken by the
>  limiting conditions of obtaining the trace result only for 
> several seconds until panic occurs. 
> 
> Regards

I'm not really taking part in the licensing discussion - its complex,
and partially personal, and I am not in a good position to advise
either way. I am not seeking to close the source or make $$$ out of it,
so from a 'free' point of view, its something the receiver will need
to decide for themselves. At best, I am adding something to the free-pool,
and not claiming any innovation or righs over the code.

The subtle difference between systemtap and dtrace - as i see it -
is that dtrace has a well thought out language. Systemtap doesnt.
The mechanisms of both are similar at a base level, but in practise
dtrace is designed to be more 'modular'. Sun spent a lot of effort
to put the hooks in to let dtrace be effective. Some of the hooks are
available in linux - some not. So its a matter of quality of implementation.

As for performance - they are possibly similar but based on different
principals. Dtrace (like systemtap) costs nothing if you dont use it.
If you do, the performance impact depends on the quality of your
scripts (but cannot cause a kernel panic or infinite loop - in theory).
Systemtap doesnt make such guarantees. The whole raison for d'etre
for dtrace/systemtap is that when you need it, you need it *bad*. And
the minor perf hit is likely acceptable for your specific use-case.

I am not an expert in dtrace or systemtap - i have knowledge of
some aspects of both, and anything i may write on the matter may
be suspect/wrong/incorrect. I hope to correct my incorrect understandings
by virtue of this project.

BTW: progress this week has been near-zero due to a fight between
me + Ubuntu to get a custom Linus kernel to boot. Hopefully the weekend
will fare better.

-pdf



