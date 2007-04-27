Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbXD0ByN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbXD0ByN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 21:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbXD0ByN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 21:54:13 -0400
Received: from isilmar.linta.de ([213.239.214.66]:55702 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755390AbXD0ByM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 21:54:12 -0400
Date: Thu, 26 Apr 2007 21:54:10 -0400
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Dave Jones <davej@redhat.com>, Nish Aravamudan <nish.aravamudan@gmail.com>,
       William Heimbigner <icxcnika@mar.tar.cc>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [PATCH] cpufreq: allow full selection of default governors
Message-ID: <20070427015410.GA9650@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Dave Jones <davej@redhat.com>,
	Nish Aravamudan <nish.aravamudan@gmail.com>,
	William Heimbigner <icxcnika@mar.tar.cc>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0704242057430.25153@server.thyself> <20070424211253.GG23598@redhat.com> <29495f1d0704241505p62140160o52d83e383106bf8e@mail.gmail.com> <20070425000327.GG22267@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425000327.GG22267@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 08:03:27PM -0400, Dave Jones wrote:
> On Tue, Apr 24, 2007 at 03:05:36PM -0700, Nish Aravamudan wrote:
>  > On 4/24/07, Dave Jones <davej@redhat.com> wrote:
>  > > On Tue, Apr 24, 2007 at 09:03:23PM +0000, William Heimbigner wrote:
>  > >  > The following patches should allow selection of conservative, powersave, and
>  > >  > ondemand in the kernel configuration.
>  > >
>  > > This has been rejected several times already.
>  > > Ondemand and conservative isn't a viable governor for all cpufreq
>  > > implementations (ie, ones with high switching latencies).
>  > 
>  > This piques my curiosity -- some governors don't work with some
>  > cpufreq implementations. Are those implementations in the kernel or in
>  > userspace? If in the kernel, then perhaps there should be some
>  > dependency expressed there in Kconfig between cpufreq implementation
>  > and the available governors
> 
> it can't be solved that easily. powernow-k8 for example is fine to
> use with ondemand on newer systems, where the latency is low.
> On older models however, it isn't.
> 
>  > > Also, see the
>  > > comment in the Kconfig a few lines above where you are adding this.
>  > 
>  > Are these governors unfixable? If
> 
> tbh, I've forgotten the original issues that caused the comment
> to be placed there. Dominik ?

Not unfixable, but: cpufreq is currently[*] built around the assumption that
at least one governor is correctly initialized or can be brought to work
when a CPU is registered with the cpufreq core.

	Dominik


[*] That is, the last time I looked at it ;)
