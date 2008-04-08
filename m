Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbYDHVBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbYDHVBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 17:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYDHVB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 17:01:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:55164 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752511AbYDHVB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 17:01:26 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18R5WcXU/IRffQBtH2I1U9VBoVUhQ8e1k2p4pHVGu
	1YAoDCnkfKKGKX
Date: Tue, 8 Apr 2008 23:01:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Dave Airlie <airlied@gmail.com>
cc: Gerhard Pircher <gerhard_pircher@gmx.net>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.25-rc6] possible regression: X server dying
In-Reply-To: <21d7e9970804071527g14402783j26bfdbd2beb1b026@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804082256270.4987@axis700.grange>
References: <47E82D68.5070305@imap.cc>  <21d7e9970803241622v10b887a6p869535102b486279@mail.gmail.com>
  <47E83D14.8070800@imap.cc>  <21d7e9970803241753q433e7545pdd00eae189846a8@mail.gmail.com>
  <21d7e9970803302153s314d48d3o7120a56092eeaede@mail.gmail.com> 
 <21d7e9970804060044i25b36802p1859ca25fa532494@mail.gmail.com> 
 <20080406143434.106940@gmx.net> <21d7e9970804071527g14402783j26bfdbd2beb1b026@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008, Dave Airlie wrote:

> On Mon, Apr 7, 2008 at 12:34 AM, Gerhard Pircher <gerhard_pircher@gmx.net> wrote:
> >
> >  Sorry for hijacking this thread, but I have a similar problem with the
> >  Xorg X server. I'm using kernel 2.6.25-rc8 on my AmigaOne (PowerPC) and
> >  the X server dies right on startup, but only if DRI/DRM is enabled.
> >  I tested this with both Xorg 7.1 (Debian Etch version) and Xorg 7.2
> >  (Lenny). The X server was working fine with kernel 2.6.25-rc6. I have
> >  to mention that the AmigaOne uses uncached memory for DMA operations.
> >  Benjamin Herrenschmidt fixed DRI recently for non cache coherent systems
> >  and his patches are working fine (I applied them to kernel 2.6.25-rc6).
> >  Please take a look at the attached Xorg.0.log file or at the excerpt
> >  below:

Hm, so looks like I'm not seeing some ghosts on mine either. 2.6.25-rc8 
xorg runs under etch, but enters a tight (no syscalls) loop woth 100% CPU 
load under lenny. A 2.6.24 based kernel works under both etch and lenny... 
Haven't had time to try to localize the problem. Glint xorg driver, DRM 
and AGP are off, CONFIG_FB_PM2=y.

Thanks
Guennadi
---
Guennadi Liakhovetski
