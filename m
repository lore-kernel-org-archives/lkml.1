Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131Ab0BYRsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:48:33 -0500
Received: from smail.sisa.samsung.com ([63.166.156.252]:53487 "EHLO
	SMAIL.sisa.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933082Ab0BYRsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:48:32 -0500
X-Greylist: delayed 1209 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Feb 2010 12:48:31 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [linuxtools-dev] Standard protocols/interfaces/formats forperformance tools (TCF, LTTng, ...)
Date: Thu, 25 Feb 2010 09:28:20 -0800
Message-ID: <D75C33A4DAF4F347A09A09B97BF978B00D783231@SMAIL.sisa.samsung.com>
In-Reply-To: <1267072349.24271.8209.camel@gandalf.stny.rr.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [linuxtools-dev] Standard protocols/interfaces/formats forperformance tools (TCF, LTTng, ...)
Thread-Index: Acq1044BflAbI0jxT82f5LDGWJilpwAa8W6g
References: <D86DB60C62D82A4792CAEC7F58CA04E706C13BB6@NA1-MAIL.mgc.mentorg.com> <20100224154021.GA9692@Krystal> <D86DB60C62D82A4792CAEC7F58CA04E706C13E65@NA1-MAIL.mgc.mentorg.com> <1267072349.24271.8209.camel@gandalf.stny.rr.com>
From: "Tasneem Brutch - SISA" <t.brutch@sisa.samsung.com>
To: <rostedt@goodmis.org>, "Spear, Aaron" <aaron_spear@mentor.com>
Cc: "Linux Tools developer discussions" <linuxtools-dev@eclipse.org>,
       <dsdp-tcf-dev@eclipse.org>, <ltt-dev@lists.casi.polymtl.ca>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I proposed, and currently chair the newly formed Multicore Association,
Tool Infrastructure work group (TIWG).  The work group welcomes
opportunities to better understand other efforts, that TIWG can
leverage, and learn from.  I will be at the Multicore Expo, where I am
presenting, and I also plan on attending the EclipseCon.  
I would very much appreciate an opportunity to talk face to face, and to
get a better understanding of other efforts.

Regards,
Tasneem Brutch, Ph.D.
Samsung Electronics US R&D Center
75 W. Plumeria Drive
San Jose, CA. 95134
Work: 408-544-5626
Cell: 408-712-7858

-----Original Message-----
From: Steven Rostedt [mailto:rostedt@goodmis.org] 
Sent: Wednesday, February 24, 2010 8:32 PM
To: Spear, Aaron
Cc: Linux Tools developer discussions; dsdp-tcf-dev@eclipse.org;
ltt-dev@lists.casi.polymtl.ca; linux-kernel@vger.kernel.org; Tasneem
Brutch - SISA
Subject: RE: [linuxtools-dev] Standard protocols/interfaces/formats
forperformance tools (TCF, LTTng, ...)

On Wed, 2010-02-24 at 14:47 -0800, Spear, Aaron wrote:
> Hi Mathieu, 
> 

Mathieu, thanks for Cc'ing me.

> > > So, as an FYI, I am planning to participate in a new tools 
> > > infrastructure working group under the auspices of the Multi-core 
> > > association (http://www.multicore-association.org).  The 
> > working group 
> > > aims to:
> > > 
> > > 1.  Identify common needs, functionality, and opportunities for 
> > > information sharing between performance analysis tools.
> > > 2.  Discussion on identifying sharable components between 
> > performance 
> > > analysis tools.
> > > 3.  Discussion on metadata dimensions of interest for 
> > standardization 
> > > (e.g., code, space, metric, time, state)

I would most definitely like to be apart of this.

> > > 
> > > Along those lines, we (Mentor) have a need for a protocol 
> > to connect 
> > > to remote trace collectors and configure trace 
> > triggering/collection, 
> > > and then efficiently download lots of binary trace data.  
> > Sound familiar?
> > > 
> > > TCF is an obvious choice for this as various companies are already

> > > using it for this purpose from what I have observed.
> > > 
> > > So, to my point:
> > > -What protocols are currently in use that we might consider as a 
> > > starting point?  I see that the linuxtools project 
> > apparently has one 
> > > for transferring LTTng event data.  Are there any docs for this 
> > > protocol?
> > > 
> > > -Is there any other company with a proprietary protocol that would

> > > consider donating it to a standardization effort? (some one 
> > else who 
> > > also desires to end the insanity :-)
> > > 
> > > -file formats: event log file formats is another obvious 
> > candidate for 
> > > standardization.  Mentor has a file format we use that was 
> > inspired by 
> > > LTTng's format but is optimized for extremely large real-time
trace 
> > > logs.  I intend to throw this into the mix.  Any others we should 
> > > think about? (The LTTng format obviously...)
> > 
> > Hi Aaron,
> > 
> > I would be glad to provide insight into the LTTng file format 
> > as needed.
> 
> Great! Insight and experience gleaned from your work is certainly
> desired.
> 
> > 
> > It would be good to ask if the Ftrace team is interested to 
> > participate in this standardization effort. Proposing 
> > modifications to the Ftrace file format is on my roadmap.
> 
> I must confess that I know nothing about Ftrace.

Here's a bunch of quick pointers:

http://people.redhat.com/srostedt/ftrace-tutorial-linux-con-2009.odp
http://lwn.net/Articles/365835/
http://lwn.net/Articles/366796/
http://lwn.net/Articles/370423/
http://lwn.net/Articles/343766/

>   That said, any prior
> art in the space of file formats and protocols for exchanging
profiling
> and trace data should be considered, and input from existing
communities
> is warmly welcomed.  The charter of this multi-core working group is
to
> help forge some interoperability standards between different tools as
a
> start.  We believe that the future will be heavily multi-core, and it
is
> a difficult problem to solve figuring out graceful ways to partition a
> complex "application" across these cores effectively.  E.g. a system
> with SMP Linux on a couple of cores, a low level RTOS on another core,
> and then some DSP's as well.  Today you often use totally different
> tools for all of those cores.  How do you understand what the heck is
> happening in this system, never mind figuring out how to optimize the
> system as a whole...   I think a good first step is some level of
> interoperability in data formats so that event data collected from
> different sources and technologies (e.g. LTTng for Linux and real-time
> trace for the DSP's) can be correlated and analyzed side by side. 

Aaron,

Let me introduce myself. I'm the author and current maintainer of
Ftrace. Ftrace was accepted in the mainline kernel in 2.6.27 and has
grown tremendously. It has a rich array of features to trace the inner
workings of the kernel.

Lately I've been working hard on a userspace tool to read from ftrace.
It uses the linux syscall splice, that allows recording of the trace
buffer into disk storage or the network with zero copy overhead (splice
lets userspace tell the kernel to move one page from one file descriptor
to another).

I'll be debuting this tool at the CELF conference this April in San
Francisco. It's called trace-cmd and you can down load the latest code
from:

$ git clone
git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git

I also have a gui tool that I will be debuting at the Linux
Collaboration Conference that takes place immediately after CELF.

-- Steve


