Return-Path: <linux-kernel-owner+w=401wt.eu-S932480AbZJ1BGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbZJ1BGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 21:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757006AbZJ1BGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 21:06:50 -0400
Received: from kroah.org ([198.145.64.141]:38978 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757014AbZJ1BGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 21:06:49 -0400
Date: Tue, 27 Oct 2009 18:06:47 -0700
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] tracefs
Message-ID: <20091028010647.GB14956@kroah.com>
References: <20091023004937.GA24035@kroah.com> <20091023053237.GA24359@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091023053237.GA24359@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 07:32:37AM +0200, Ingo Molnar wrote:
> 
> * Greg KH <greg@kroah.com> wrote:
> 
> > Hi all,
> > 
> > At LinuxCon this year, Steven and I talked about moving the debugfs 
> > usage in the tracing core to a stand-alone filesystem to give the 
> > ability to start to lock down the api so that people an count on what 
> > is going on in the tracing userspace interface.
> 
> What we want to move out initially (and i talked to Steve and Frederic 
> about that a few weeks ago) is the event description bits - the format 
> stuff in /debug/tracing/events/ - but definitely not all the other, 
> rather messy and ad-hoc APIs.
> 
> _No way_ do we want to tie down the pretty-printing ftrace details as an 
> ABI. We promised that when ftrace went upstream and all the details are 
> way too messy to be exposed in an ABI alike matter (and yes, consider 
> this a NAK Steve ;-).

Ok, I'll drop this.  There was some cleanups I found, I'll pick those
out and send them on.  What tree should I base off of to send cleanup
patches to?

thanks,

greg k-h
