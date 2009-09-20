Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbZITHkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbZITHkO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 03:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbZITHkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 03:40:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:51134 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbZITHkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 03:40:13 -0400
Date: Sun, 20 Sep 2009 09:40:22 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Tim Blechmann <tim@klingt.org>
Cc: linux-kernel@vger.kernel.org, Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: tickless and HZ=1000 throughput advantage?
Message-ID: <20090920094022.0609f56c@infradead.org>
In-Reply-To: <4AB5DB06.1090100@klingt.org>
References: <6278d2220909190747n62f7036dj2e5231fcdc4730fb@mail.gmail.com>
	<20090919165501.65d77294@infradead.org>
	<6278d2220909191050l19f2a446r5ccf1907fd963096@mail.gmail.com>
	<1253401950.7587.7.camel@ben-desktop>
	<4AB5DB06.1090100@klingt.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Sep 2009 09:34:30 +0200
Tim Blechmann <tim@klingt.org> wrote:

> On 09/20/2009 01:12 AM, Ben Nizette wrote:
> > On Sat, 2009-09-19 at 18:50 +0100, Daniel J Blueman wrote:
> > 
> >> Agreed. Do you think there is still a small case for moving to
> >> HZ=1000 (given it's effectively free) in situations like:
> > 
> > Sure HZ=1000 gives you more accurate sleeps, that's kind of the
> > point, but since when has it been "effectively free"?
> > http://lwn.net/Articles/331607/
> 
> i'd be curious, what effect does it have on userspace applications?
> like, does it effect the wakeup latency of userspace (pthread)
> mutexes/conditions or posix semaphores?

the impact to userspace should be zero nowadays since select/poll/etc
moved to hrtimers, which are HZ-independent.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
