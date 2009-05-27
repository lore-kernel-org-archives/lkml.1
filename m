Return-Path: <linux-kernel-owner+w=401wt.eu-S932352AbZE0TRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbZE0TRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760715AbZE0TRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:17:00 -0400
Received: from kroah.org ([198.145.64.141]:36004 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758689AbZE0TQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:16:59 -0400
Date: Wed, 27 May 2009 12:13:10 -0700
From: Greg KH <greg@kroah.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       GeunSik Lim <leemgs1@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org,
       balagi@justmail.de, bgamari@gmail.com, Ingo Molnar <mingo@elte.hu>,
       inaky.perez-gonzalez@intel.com
Subject: Re: [RFC PATCH]debugfs:Fix terminology inconsistency of dir name
	to mount debugfs filesystem.
Message-ID: <20090527191310.GA466@kroah.com>
References: <1243315163.14685.17.camel@centos51> <alpine.DEB.2.00.0905261642130.26705@gandalf.stny.rr.com> <20090526205414.GA26016@kroah.com> <alpine.DEB.2.00.0905261711310.26705@gandalf.stny.rr.com> <49b7c2350905261924h34e5f019g9e38735bb64bbf87@mail.gmail.com> <alpine.DEB.2.00.0905262231210.27902@gandalf.stny.rr.com> <1243403437.3118.10.camel@localhost.localdomain> <alpine.DEB.2.00.0905271418290.17378@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905271418290.17378@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 02:22:37PM -0400, Steven Rostedt wrote:
> 
> On Wed, 27 May 2009, Jaswinder Singh Rajput wrote:
> 
> > Hello Steve,
> > 
> > On Tue, 2009-05-26 at 22:38 -0400, Steven Rostedt wrote:
> > 
> > > If you look in Documentation/trace/ftrace.txt I have:
> > > 
> > > ===
> > > To mount the debugfs system:
> > > 
> > >   # mkdir /debug
> > >   # mount -t debugfs nodev /debug
> > > 
> > > ( Note: it is more common to mount at /sys/kernel/debug, but for
> > >   simplicity this document will use /debug)
> > > ===
> > > 
> > 
> > Please standardize Documentation/trace/ftrace.txt and avoid confusion to
> > users:
> > 
> > ===
> > To mount the debugfs system:
> > 
> >   # mount -t debugfs nodev /sys/kernel/debug
> > ===
> 
> I really don't want to do that. Then I would need to show
> 
>  # echo function_graph > /sys/kernel/debug/current_trace
> 
> Which I really do not like. I state that the common place to mount it is 
> in /sys/kernel/debug, But my examples are much easier to understand if
> I just do: # echo function_graph > /debug/current_trace

It's not just the "common" place, it is the DOCUMENTED PLACE.

I'm sorry you have to type a long path, perhaps you wish to invest in a
tab key for auto-completion :)

Again, distros already mount debugfs at this location, please don't
confuse people just because you are annoyed at the length of the path.

thanks,

greg k-h
