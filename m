Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbZCJNjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbZCJNjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbZCJNjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:39:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55274 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542AbZCJNjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:39:05 -0400
Date: Tue, 10 Mar 2009 09:39:03 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] doc: add trace_buf_size description to
 kernel-parameters.txt
In-Reply-To: <alpine.DEB.2.00.0903100933280.4802@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0903100938440.4802@gandalf.stny.rr.com>
References: <20090310135200.A48B.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0903100933280.4802@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 10 Mar 2009, Steven Rostedt wrote:
> On Tue, 10 Mar 2009, KOSAKI Motohiro wrote:
> 
> > from early boot tracing view, trace_buf_size parameter is important.
> > it should be documented.
> > 
> > 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > ---
> >  Documentation/kernel-parameters.txt |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index dd35cb7..8869faa 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -2349,6 +2349,8 @@ and is between 256 and 4096 characters. It is defined in the file
> >  
> >  	tp720=		[HW,PS2]
> >  
> > +	trace_buf_size=nn[KMG] [ftrace] will set tracing buffer size.
> > +
> >  	trix=		[HW,OSS] MediaTrix AudioTrix Pro
> >  			Format:
> >  			<io>,<irq>,<dma>,<dma2>,<sb_io>,<sb_irq>,<sb_dma>,<mpu_io>,<mpu_irq>
> > -- 
> > 1.6.1.2
> 
> Thanks Kosaki,
> 
> I'll apply this to my next release.

Nevermind, it is already in tip. ;-)

-- Steve
