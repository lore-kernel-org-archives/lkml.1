Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbZHaTqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbZHaTqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 15:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZHaTqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 15:46:49 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:51383 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbZHaTqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 15:46:48 -0400
Date: Mon, 31 Aug 2009 21:46:44 +0200
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: srostedt@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] tracing: remove mentioning of legacy latency_trace
 file from documentation
Message-ID: <20090831194644.GD4237@pc-ras4041.res.insa>
References: <1251744635-14926-1-git-send-email-albin.tonnerre@free-electrons.com>
 <20090831190852.GC6048@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831190852.GC6048@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 09:08:54PM +0200, Frederic Weisbecker wrote :
> On Mon, Aug 31, 2009 at 08:50:35PM +0200, Albin Tonnerre wrote:
> >  
> > @@ -307,8 +299,8 @@ the lowest priority thread (pid 0).
> >  Latency trace format
> >  --------------------
> >  
> > -For traces that display latency times, the latency_trace file
> > -gives somewhat more information to see why a latency happened.
> > +For traces that display latency times, the trace file gives
> > +somewhat more information to see why a latency happened.
> 
> 
> 
> Hmm, now that the latency_trace file has disappeared, this sentence
> doesn't make sens anymore.
> The trace file gives more information about latency than...? :-)
> 
> Actually the latency format still exists.
> It's toggable through the latency-format trace option:
> 
> echo latency-format > trace_options
> 
> I guess this documentation should actually not make the latency
> format documentation disappear but actually mirror the moving from
> a file to an option.

Right, I'll do that. Actually this patch doesn't really make it disappear, as
the format is still described here. I agree that the above paragraph should be
rephrased to mention that i's available through the latency-format option.

> >    delay: This is just to help catch your eye a bit better. And
> >  	 needs to be fixed to be only relative to the same CPU.
> > @@ -440,7 +432,8 @@ Here are the available options:
> >    sym-addr:
> >     bash-4000  [01]  1477.606694: simple_strtoul <c0339346>
> >  
> > -  verbose - This deals with the latency_trace file.
> > +  verbose - This deals with the trace file when it
> > +            displays lantecy times.
> 
> 
> "latency"

thanks

> Is it true when latency-format is not selected?

No, it only applies when latency-format is selected.

Regards,
-- 
Albin Tonnerre, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
