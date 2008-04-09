Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbYDIIyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbYDIIyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 04:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbYDIIyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 04:54:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:46734 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751871AbYDIIyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 04:54:37 -0400
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="iso-8859-1"
Date: Wed, 09 Apr 2008 10:54:35 +0200
From: "Gerhard Pircher" <gerhard_pircher@gmx.net>
In-Reply-To: <Pine.LNX.4.64.0804082256270.4987@axis700.grange>
Message-ID: <20080409085435.232570@gmx.net>
MIME-Version: 1.0
References: <47E82D68.5070305@imap.cc> 
 <21d7e9970803241622v10b887a6p869535102b486279@mail.gmail.com> 
 <47E83D14.8070800@imap.cc> 
 <21d7e9970803241753q433e7545pdd00eae189846a8@mail.gmail.com> 
 <21d7e9970803302153s314d48d3o7120a56092eeaede@mail.gmail.com> 
 <21d7e9970804060044i25b36802p1859ca25fa532494@mail.gmail.com> 
 <20080406143434.106940@gmx.net>
 <21d7e9970804071527g14402783j26bfdbd2beb1b026@mail.gmail.com>
 <Pine.LNX.4.64.0804082256270.4987@axis700.grange>
Subject: Re: [2.6.25-rc6] possible regression: X server dying
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, airlied@gmail.com
X-Authenticated: #6097454
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19T5l095sRTFgDmz6hOMAmmbWwgZeZnrVa4VqYPTl
 H8fqrx4PVQANoiEy7VkE2kAsLU+Dt+fN4X4A== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: HOGOZ707eSEqbU9pNnQhuLh+IGRvbwAV
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
> Datum: Tue, 8 Apr 2008 23:01:26 +0200 (CEST)
> Von: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> An: Dave Airlie <airlied@gmail.com>
> CC: Gerhard Pircher <gerhard_pircher@gmx.net>, linux-kernel@vger.kernel.org
> Betreff: Re: [2.6.25-rc6] possible regression: X server dying

> On Tue, 8 Apr 2008, Dave Airlie wrote:
> 
> > On Mon, Apr 7, 2008 at 12:34 AM, Gerhard Pircher
> <gerhard_pircher@gmx.net> wrote:
> > >
> > >  Sorry for hijacking this thread, but I have a similar problem with
> > >  the Xorg X server. I'm using kernel 2.6.25-rc8 on my AmigaOne
> > >  (PowerPC) and the X server dies right on startup, but only if
> > >  DRI/DRM is enabled. I tested this with both Xorg 7.1 (Debian Etch
> > >  version) and Xorg 7.2 (Lenny). The X server was working fine with
> > >  kernel 2.6.25-rc6. I have to mention that the AmigaOne uses uncached 
> > >  memory for DMA operations. Benjamin Herrenschmidt fixed DRI recently
> > >  for non cache coherent systems and his patches are working fine (I
> > >  applied them to kernel 2.6.25-rc6).
> > >  Please take a look at the attached Xorg.0.log file or at the excerpt
> > >  below:
> 
> Hm, so looks like I'm not seeing some ghosts on mine either. 2.6.25-rc8
> xorg runs under etch, but enters a tight (no syscalls) loop woth 100% CPU 
> load under lenny. A 2.6.24 based kernel works under both etch and
> lenny...
Strange! I guess I should recompile the kernel and test again. :(
I also experienced a high load under Lenny, but IIRC this showed up under
an older kernel (2.6.18), too (after X server is started, standard
installation, no additional packages).

> Haven't had time to try to localize the problem. Glint xorg driver, DRM 
> and AGP are off, CONFIG_FB_PM2=y.
The X server only dies on my machine, if DRM is on. I read somewhere that
the lastest DRM patches need a newer Xorg version (~7.3). Could that be
the problem with kernel 2.6.25-rc8?

Thanks!

Gerhard
-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört?
Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger
