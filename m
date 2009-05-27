Return-Path: <linux-kernel-owner+w=401wt.eu-S933640AbZE0SYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640AbZE0SYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933471AbZE0SWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:22:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51993 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933495AbZE0SWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:22:37 -0400
Date: Wed, 27 May 2009 14:22:37 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: GeunSik Lim <leemgs1@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org,
       balagi@justmail.de, bgamari@gmail.com, Ingo Molnar <mingo@elte.hu>,
       inaky.perez-gonzalez@intel.com
Subject: Re: [RFC PATCH]debugfs:Fix terminology inconsistency of dir name to
 mount debugfs filesystem.
In-Reply-To: <1243403437.3118.10.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0905271418290.17378@gandalf.stny.rr.com>
References: <1243315163.14685.17.camel@centos51>  <alpine.DEB.2.00.0905261642130.26705@gandalf.stny.rr.com>  <20090526205414.GA26016@kroah.com>  <alpine.DEB.2.00.0905261711310.26705@gandalf.stny.rr.com>  <49b7c2350905261924h34e5f019g9e38735bb64bbf87@mail.gmail.com>
  <alpine.DEB.2.00.0905262231210.27902@gandalf.stny.rr.com> <1243403437.3118.10.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 27 May 2009, Jaswinder Singh Rajput wrote:

> Hello Steve,
> 
> On Tue, 2009-05-26 at 22:38 -0400, Steven Rostedt wrote:
> 
> > If you look in Documentation/trace/ftrace.txt I have:
> > 
> > ===
> > To mount the debugfs system:
> > 
> >   # mkdir /debug
> >   # mount -t debugfs nodev /debug
> > 
> > ( Note: it is more common to mount at /sys/kernel/debug, but for
> >   simplicity this document will use /debug)
> > ===
> > 
> 
> Please standardize Documentation/trace/ftrace.txt and avoid confusion to
> users:
> 
> ===
> To mount the debugfs system:
> 
>   # mount -t debugfs nodev /sys/kernel/debug
> ===

I really don't want to do that. Then I would need to show

 # echo function_graph > /sys/kernel/debug/current_trace

Which I really do not like. I state that the common place to mount it is 
in /sys/kernel/debug, But my examples are much easier to understand if
I just do: # echo function_graph > /debug/current_trace

-- Steve

