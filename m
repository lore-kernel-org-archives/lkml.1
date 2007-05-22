Return-Path: <linux-kernel-owner+w=401wt.eu-S1762462AbXEVRf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762462AbXEVRf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 13:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbXEVRfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 13:35:51 -0400
Received: from main.gmane.org ([80.91.229.2]:39336 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756727AbXEVRfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 13:35:50 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jindrich Makovicka <makovick@gmail.com>
Subject: Re: Enabling power states for Core 2 Duo
Date: Tue, 22 May 2007 19:35:19 +0200
Message-ID: <20070522193519.53f0021e@holly>
References: <8aa016e10705220937t6cfbacbj4fe8fc97d135924@mail.gmail.com>
	<BAY20-F1412F1EDFF34450CE1F213F9360@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: kmlinux.fjfi.cvut.cz
In-Reply-To: <BAY20-F1412F1EDFF34450CE1F213F9360@phx.gbl>
X-Newsreader: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007 17:14:45 +0000
"Paa Paa" <paapaa125@hotmail.com> wrote:

> >>But are you saying that with most desktop mobos one doesn't usually
> >>have the
> >>different power states available at all? So basically the only
> >>means to conserve power is to scale the frequency?
> >>
> >
> >Please update your BIOS and try.
> 
> I updated my Asus P5B Deluxe BIOS with no luck (this latest BIOS is
> about 1 month old). Still no power states. I would be nice to know if
> _any_ desktop C2D mobos have these C-states? (In x86_64 system).
> 
> I think I never mentioned:
> 
> I'm using 2.6.21.1 (actually gentoo-sources-2.6.21-r1)
> My CPU is E6400.

I observe the same problem with Gigabyte 965P-DS4, and there are at
least two causes - 1) MP supported flag in FADT is missing (so
CPU_HOTPLUG would be necessary), and 2) C2 latency is set to 101,
while the maximum allowed in the kernel is 100.

However, from the power consumption and the CPU temperature it seems
that the power saving works anyway, so I'll live with it.

-- 
Jindrich Makovicka

