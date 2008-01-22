Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbYAVS6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbYAVS6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 13:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYAVS6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 13:58:45 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:53566 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbYAVS6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 13:58:44 -0500
Date: Tue, 22 Jan 2008 19:58:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Michael Opdenacker <michael-lists@free-electrons.com>,
       linux-kernel@vger.kernel.org, Linux-tiny@selenic.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: fix unconditional arch/x86/kernel/pcspeaker.c?compiling
Message-ID: <20080122185840.GA9700@uranus.ravnborg.org>
References: <20080118122540.GH11044@elte.hu> <20080118122926.GA15216@elte.hu> <4790A385.800@free-electrons.com> <1200664214.4001.24.camel@cinder.waste.org> <4790D3E3.4060409@free-electrons.com> <1200676219.3835.8.camel@cinder.waste.org> <20080118210938.GE10717@elte.hu> <1200695950.25782.28.camel@cinder.waste.org> <20080122143912.GJ7304@elte.hu> <1201019839.14436.30.camel@cinder.waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201019839.14436.30.camel@cinder.waste.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 10:37:19AM -0600, Matt Mackall wrote:
> 
> On Tue, 2008-01-22 at 15:39 +0100, Ingo Molnar wrote:
> > threadinfo-ool.patch: doesnt this break the scheduler? 
> 
> It didn't when I wrote it, 3+ years ago. But I'm sure it needs to be
> revisited.
> 
> > tiny-cflags.patch: obsolete? Isnt CFLAGS already extendable? Question to 
> > Sam i guess.
And what was the question then?

We have today the possibility to say:
make KCFLAGS=-whatever

and we have plenty of kconfig adjustmenst affecting the gcc options.

I do not know if this covers it.

	Sam
