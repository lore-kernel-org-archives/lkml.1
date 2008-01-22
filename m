Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbYAVTRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbYAVTRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 14:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYAVTRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 14:17:41 -0500
Received: from waste.org ([66.93.16.53]:39813 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbYAVTRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 14:17:40 -0500
Subject: Re: [PATCH] x86: fix unconditional
	arch/x86/kernel/pcspeaker.c?compiling
From: Matt Mackall <mpm@selenic.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Michael Opdenacker <michael-lists@free-electrons.com>,
       linux-kernel@vger.kernel.org, Linux-tiny@selenic.com,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080122185840.GA9700@uranus.ravnborg.org>
References: <20080118122540.GH11044@elte.hu>
	 <20080118122926.GA15216@elte.hu> <4790A385.800@free-electrons.com>
	 <1200664214.4001.24.camel@cinder.waste.org>
	 <4790D3E3.4060409@free-electrons.com>
	 <1200676219.3835.8.camel@cinder.waste.org> <20080118210938.GE10717@elte.hu>
	 <1200695950.25782.28.camel@cinder.waste.org>
	 <20080122143912.GJ7304@elte.hu>
	 <1201019839.14436.30.camel@cinder.waste.org>
	 <20080122185840.GA9700@uranus.ravnborg.org>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 13:17:07 -0600
Message-Id: <1201029427.14436.54.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-22 at 19:58 +0100, Sam Ravnborg wrote:
> On Tue, Jan 22, 2008 at 10:37:19AM -0600, Matt Mackall wrote:
> > 
> > On Tue, 2008-01-22 at 15:39 +0100, Ingo Molnar wrote:
> > > threadinfo-ool.patch: doesnt this break the scheduler? 
> > 
> > It didn't when I wrote it, 3+ years ago. But I'm sure it needs to be
> > revisited.
> > 
> > > tiny-cflags.patch: obsolete? Isnt CFLAGS already extendable? Question to 
> > > Sam i guess.
> And what was the question then?
> 
> We have today the possibility to say:
> make KCFLAGS=-whatever
> 
> and we have plenty of kconfig adjustmenst affecting the gcc options.
> 
> I do not know if this covers it.

Basically the idea was you could specify various flags that affected
kernel size, in particular overriding the various bloated alignment
defaults.

If I were to do this today (if they haven't already become the default),
I'd probably add a config var to request minimal alignment instead.

-- 
Mathematics is the supreme nostalgia of our time.

