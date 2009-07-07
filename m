Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbZGGCh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbZGGCh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 22:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZGGCht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 22:37:49 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:31156 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbZGGChs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 22:37:48 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jul 2009 22:37:48 EDT
X-SpamScore: -29
X-BigFish: VPS-29(z34a4jz1432R98dN1447R1805Mzz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4A52B155.2080000@am.sony.com>
Date: Mon, 6 Jul 2009 19:22:13 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] ftrace: Add duration filtering to function graph
 tracer
References: <4A528769.5020200@am.sony.com> <alpine.DEB.2.00.0907062017510.8813@gandalf.stny.rr.com> <4A52A74D.8000005@am.sony.com> <alpine.DEB.2.00.0907062212370.8813@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0907062212370.8813@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jul 2009 02:22:14.0326 (UTC) FILETIME=[BDC14D60:01C9FEA9]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Mon, 6 Jul 2009, Tim Bird wrote:
>> Another thing I thought of was to not commit the entry event until function
>> exit.  I'm not sure the ring buffer supports having an entry outstanding for
>> long periods of time, though. This would, I believe, hold readers at the entries for
>> the last 'completed' functions, which might solve reader/writer races.
> 
> Heh, I doubt that would be acceptable. The problem is that between reserve 
> and commit, we disable preemption. Thus every function (even the scheduler 
> itself) would have preemption disabled ;-)

Doh!  I think I saw that, but only had a vague recollection of it.
Yeah, that would be a problem ;-)

I'll give the issues some more thought, and see if I can come
up with something.

Thanks for the feedback.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

