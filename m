Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbXKITlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbXKITlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 14:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbXKITk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 14:40:59 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:47788 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344AbXKITk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 14:40:58 -0500
Date: Fri, 9 Nov 2007 20:42:38 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unification of cfufreq/Kconfig
Message-ID: <20071109194238.GB3809@uranus.ravnborg.org>
References: <11943900793940-git-send-email-sam@ravnborg.org> <20071106230451.GA10886@uranus.ravnborg.org> <20071109183602.GD1988@alberich.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071109183602.GD1988@alberich.amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 07:36:02PM +0100, Andreas Herrmann wrote:
> On Wed, Nov 07, 2007 at 12:04:51AM +0100, Sam Ravnborg wrote:
> > This serie of patches unify the X86 Kconfig files.
> > Next step is to enable use of "make ARCH=x86" and kill
> > "make ARCH=i386/x86_64".
> > But that will wait till tomorrow.
> > 
> > The allmodconfig kernel is still building here.
> > Testing / reviews appreciated.
> > 
> > Comments from former patchset is addressed - see
> > changelog entries.
> 
> Just some kind of feedback wrt your patch set.
> I did several hundred randconfig kernel compiles based
> on 2.6.24-rc2 with your patches on top plus those additional
> minor fixes mentioned on lkml.
> 
> >From what I've seen there were no compile failures that seem
> to be caused by your adaptations.
> 
> Mostly I have seen the ususal suspects (e.g. missing firmware and
> lots of failed configs due to conflicting types for net_free 
> - AFAIK that is already solved in netdev tree - and due to the
> "kvm-smp_call_function-issue").
> 
> The rest (5 failed configs) was not specific to x86 but driver
> related (e.g. v4l).

Hi Andreas.

Thanks for your testing effort. This is great!

	Sam
