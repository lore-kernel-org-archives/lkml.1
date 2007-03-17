Return-Path: <linux-kernel-owner+w=401wt.eu-S1750895AbXCQPqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750895AbXCQPqM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 11:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbXCQPqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 11:46:12 -0400
Received: from sigma957.CIS.McMaster.CA ([130.113.64.83]:36588 "EHLO
	sigma957.cis.mcmaster.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbXCQPqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 11:46:11 -0400
X-Greylist: delayed 1896 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Mar 2007 11:46:11 EDT
Date: Sat, 17 Mar 2007 11:13:26 -0400 (EDT)
From: Mark Hahn <hahn@mcmaster.ca>
X-X-Sender: hahn@coffee.psychology.mcmaster.ca
To: Con Kolivas <kernel@kolivas.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: RSDL v0.31
In-Reply-To: <200703172048.46267.kernel@kolivas.org>
Message-ID: <Pine.LNX.4.64.0703171105270.16125@coffee.psychology.mcmaster.ca>
References: <200703042335.26785.a1426z@gawab.com> <20070317074506.GA13685@elte.hu>
 <87fy84i7nn.fsf@depni.sinp.msu.ru> <200703172048.46267.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-PMX-Version-Mac: 4.7.1.128075, Antispam-Engine: 2.5.0.283055, Antispam-Data: 2007.3.17.75433
X-PerlMx-Spam: Gauge=IIIIIII, Probability=7%, Report='__CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So in an attempt to summarise the situation, what are the advantages of RSDL
> over mainline.
>
> Fairness

why do you think fairness is good, especially always good?

> Starvation free

even starvation is sometimes a good thing - there's a place for processes
that only use the CPU if it is otherwise idle.  that is, they are
deliberately starved all the rest of the time.

> Much lower and bound latencies

in an average sense?  also, under what circumstances does this actually
matter?  (please don't offer something like RT audio on an overloaded machine-
that's operator error, not something to design for.)

> Deterministic

not a bad thing, but how does this make itself apparent and of value 
to the user?  I think everyone is extremely comfortable with non-determinism
(stemming from networks, caches, interleaved workloads, etc)

> Better interactivity for the majority of cases.

how is this measured?  is this statement really just a reiteration of 
the latency claim?

> Now concentrating on the very last aspect since that seems to be the sticking
> point.

nah, I think the fairness and latency claims are the real issues.
