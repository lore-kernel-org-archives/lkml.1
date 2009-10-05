Return-Path: <linux-kernel-owner+w=401wt.eu-S1752491AbZJEOYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbZJEOYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 10:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZJEOYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 10:24:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:48954 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbZJEOYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 10:24:40 -0400
Date: Mon, 5 Oct 2009 07:24:28 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Frans Pop <elendil@planet.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for
 CPU"
Message-ID: <20091005072428.16ce40e4@infradead.org>
In-Reply-To: <200910051613.32631.elendil@planet.nl>
References: <200910051500.55875.elendil@planet.nl>
	<200910051613.32631.elendil@planet.nl>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Oct 2009 16:13:31 +0200
Frans Pop <elendil@planet.nl> wrote:

> On Monday 05 October 2009, Frans Pop wrote:
> > With .32-rc3 I'm getting occasional skips from amarok while playing
> > music from an NFS share (3 today so far), something I've not had in
> > a long time.
> >
> > The reason looks to be that latencytop consistently shows 'iwlagn'
> > as the top affected process with "Scheduler: waiting for CPU".
> > Values of 100-140 ms occur frequently, but I've also seen higher
> > values (180, 207). I don't remember seeing iwlagn high in the list
> > before, but I have not checked earlier kernels yet.
> >
> > Added to that 'phy0' also frequently shows high with values of
> > 25-75 ms.
> >
> > The system is otherwise essentially idle. Other processes typically
> > show a latency < 5 ms.
> 
> If I give the system some work to do (like compiling a kernel), the 
> latencies on iwlagn and phy0 disappear (values < 5 ms).
> Is this related to ondemand frequency scaling?

shouldn't be.... but

can you do a 5 second or so timechart recording of this?
That will capture all scheduler delays as well as the P states etc....

(to do a timechart recording, first make sure debugfs is mounted, and
then do in tools/perf 

./perf timechart record sleep 5

then you can turn it into an SVG with

./perf timechart

)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
