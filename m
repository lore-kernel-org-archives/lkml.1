Return-Path: <linux-kernel-owner+w=401wt.eu-S1751729AbZJWJij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbZJWJij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 05:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZJWJij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 05:38:39 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:49171 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZJWJii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 05:38:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vS/kgJ9kuG+A4YTfd0TUDXfCnFugiobD61Sjiv8Lr+a3NPh+dVOKYbINnBFCKToLbi
         e0yaxF3buhfz2PTw0uRENurCYouofcEIkBUUXV1z9p/inb6cuZ24sKrdjQ0qAYBhRvG+
         +RhCZpz6zm4Bp4uAZk/TPVoAyZr5qMp3TUuMA=
Date: Fri, 23 Oct 2009 11:38:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <greg@kroah.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] tracefs
Message-ID: <20091023093838.GA4939@nowhere>
References: <20091023004937.GA24035@kroah.com> <20091023053237.GA24359@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091023053237.GA24359@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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
> 
> We want a _very_ careful exporting of certain pieces of information that 
> helps syscall-exposed perf events bits, and to improve the quality of 
> interfaces while we do that.
> 
> 	Ingo


I guess the first bits that need to be exported are the TRACE_EVENT_ABI.
But even before that, we need to ensure we have a final version of
the trace events description.

