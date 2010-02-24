Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab0BXPkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 10:40:24 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:36968 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab0BXPkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 10:40:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKPVhEtGGOM5/2dsb2JhbACbEHSvLAmNUwKCSxyCCQSDFg
Date: Wed, 24 Feb 2010 10:40:21 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linux Tools developer discussions <linuxtools-dev@eclipse.org>
Cc: dsdp-tcf-dev@eclipse.org, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: [linuxtools-dev] Standard protocols/interfaces/formats for
	performance tools (TCF, LTTng, ...)
Message-ID: <20100224154021.GA9692@Krystal>
References: <D86DB60C62D82A4792CAEC7F58CA04E706C13BB6@NA1-MAIL.mgc.mentorg.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <D86DB60C62D82A4792CAEC7F58CA04E706C13BB6@NA1-MAIL.mgc.mentorg.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:25:44 up 69 days, 23:44,  4 users,  load average: 0.06, 0.07,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Spear, Aaron (aaron_spear@mentor.com) wrote:
> Hello everyone,
> 
> As some of you know, at Mentor Graphics we are currently working on
> multi-core profiling products for embedded systems.  The focus currently
> is using real-time trace data as the event source for analysis.  In the
> future this will expand as we desire to be able to correlate analysis of
> heterogeneous systems, e.g. embedded Linux + LTTng events on one
> machine, correlated with real-time trace data collected from a bunch of
> DSP's. 
> 
> Like the rest of you, we have spent much time in the past inventing
> proprietary data collection frameworks, mechanisms and formats only to
> eventually throw them away because a standard eventually emerges.  We
> would like to stop the insanity.
> 
> So, as an FYI, I am planning to participate in a new tools
> infrastructure working group under the auspices of the Multi-core
> association (http://www.multicore-association.org).  The working group
> aims to:
> 
> 1.  Identify common needs, functionality, and opportunities for
> information sharing between performance analysis tools.
> 2.  Discussion on identifying sharable components between performance
> analysis tools.
> 3.  Discussion on metadata dimensions of interest for standardization
> (e.g., code, space, metric, time, state)
> 
> Along those lines, we (Mentor) have a need for a protocol to connect to
> remote trace collectors and configure trace triggering/collection, and
> then efficiently download lots of binary trace data.  Sound familiar?  
> 
> TCF is an obvious choice for this as various companies are already using
> it for this purpose from what I have observed.
> 
> So, to my point:
> -What protocols are currently in use that we might consider as a
> starting point?  I see that the linuxtools project apparently has one
> for transferring LTTng event data.  Are there any docs for this
> protocol?
> 
> -Is there any other company with a proprietary protocol that would
> consider donating it to a standardization effort? (some one else who
> also desires to end the insanity :-)
> 
> -file formats: event log file formats is another obvious candidate for
> standardization.  Mentor has a file format we use that was inspired by
> LTTng's format but is optimized for extremely large real-time trace
> logs.  I intend to throw this into the mix.  Any others we should think
> about? (The LTTng format obviously...) 

Hi Aaron,

I would be glad to provide insight into the LTTng file format as needed.

It would be good to ask if the Ftrace team is interested to participate
in this standardization effort. Proposing modifications to the Ftrace
file format is on my roadmap.

I'm curious.. which version of the LTTng trace file format have you
derived your own format from ?

Thanks,

Mathieu

> 
> Best regards,
> Aaron
> 
> --
> Aaron Spear      
> Debug Tools Architect/Staff Engineer
> Embedded Systems Division
> Mentor Graphics Corporation
> Office: 303-679-8457
> 
> 
> _______________________________________________
> linuxtools-dev mailing list
> linuxtools-dev@eclipse.org
> https://dev.eclipse.org/mailman/listinfo/linuxtools-dev
> 

-- 
Mathieu Desnoyers
Operating System Efficiency Consultant
EfficiOS Inc.
http://www.efficios.com
