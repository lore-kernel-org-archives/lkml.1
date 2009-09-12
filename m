Return-Path: <linux-kernel-owner+w=401wt.eu-S1753799AbZILLEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbZILLEL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 07:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbZILLEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 07:04:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:43134 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbZILLEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 07:04:07 -0400
Date: Sat, 12 Sep 2009 13:07:37 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, peterz@infradead.org
Subject: [patch 0/8] Introducing the "timechart" tool
Message-ID: <20090912130737.2d55adc0@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[note: since this is a visualization tool, and lkml doesn't like html email,
it's probably better to read the online version at

http://blog.fenrus.org/?p=5 

in which I also show screenshots of the tool. The following text 
is the first part of the online introduction]

Finding out why your Linux computer performs the way it does has been a hard
task. Sure, there is Oprofile, and even ‘perf’ in recent kernels. There is
LatencyTOP to find out where latencies happen.

But all of these tools are rather limited when the software stack that has
the performance issue is more complex than a single program. The tool that
comes closest to being useful is `bootchart‘, but that has a rather limited
resolution.

To solve this, I have been working on a new tool, called Timechart, that has
the objective to show on a system level what is going on, at various levels
of detail. In fact. one of the design ideas behind timechart is that the
output should be “infinitely zoomable”; that is, if you want to know more
details about something, you should be able to zoom in to get these details.
The rest of this blog post describes some aspects of timechart, using real
life examples and screenshots. However, it is really hard to show the power
of timechart on such a static page, to get a real feeling of what timechart
can show you really ought to try it out yourself.....


I'm still looking for a better name for the tool, so if you have any ideas
please let me know...



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
