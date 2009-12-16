Return-Path: <linux-kernel-owner+w=401wt.eu-S1757838AbZLPVaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838AbZLPVaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 16:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757696AbZLPVa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 16:30:28 -0500
Received: from outbound-mail-152.bluehost.com ([67.222.39.32]:54097 "HELO
	outbound-mail-152.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757047AbZLPVa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 16:30:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hcz5OF6+J2UWKcE6EqtzUHIh2mhYwkalN+por6X3733FHnt4BtXtF8OIob4htl9YfFEw/2AGdLi8gjeU1aA/FyyhFsZOSath1jt1q18jrkTa1u1Xr2J2YFju6Qfw2SHF;
Date: Wed, 16 Dec 2009 13:30:05 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Airlie <airlied@redhat.com>, Daniel Vetter <daniel@ffwll.ch>,
       Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, keithp@keithp.com, eric@anholt.net,
       Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes
 when ..."
Message-ID: <20091216133005.0e822950@jbarnes-piketon>
In-Reply-To: <200912162120.34163.arnd@arndb.de>
References: <200912071830.14697.arnd@arndb.de>
	<200912161453.12100.arnd@arndb.de>
	<20091216121823.08b5f0a6@jbarnes-piketon>
	<200912162120.34163.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009 21:20:34 +0000
Arnd Bergmann <arnd@arndb.de> wrote:

> On Wednesday 16 December 2009 20:18:23 Jesse Barnes wrote:
> > On Wed, 16 Dec 2009 14:53:11 +0100
> > Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > > It's working fine so far, no more crashes, but I supposed this
> > > effectively disables the power saving on my card again, right?
> > 
> > The patch just disables one (probably ineffective) power saving
> > feature.  So if things are working well for you with it I'll queue
> > up a revert patch.  I'm working on a better version of dynamic
> > clock control anyway.
> 
> It just crashed again after a few hours of uptime with some unrelated
> reboots in-between, with your patch applied.
> 
> The symptom was slightly different, now the whole screen was filled
> with random patterns, not just parts of the screen. Aside from that,
> it was just the same complete lockup as without the patch. Possibly
> less frequent, but that's hard to tell after a single sample.

But you're sure powersave=0 was solid?  Hmm...

-- 
Jesse Barnes, Intel Open Source Technology Center
