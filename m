Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab0CEA42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 19:56:28 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:42624 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab0CEA4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 19:56:21 -0500
Date: Fri, 5 Mar 2010 01:56:17 +0100
From: Luc Verhaegen <libv@skynet.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100305005617.GA31883@skynet.be>
References: <20100304103929.6eb81d45@jbarnes-piketon> <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain> <20100304105624.70fe845e@jbarnes-piketon> <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain> <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com> <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain> <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com> <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain> <1267748927.3496.6.camel@nisroch> <alpine.LFD.2.00.1003041635280.3751@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003041635280.3751@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 04:41:19PM -0800, Linus Torvalds wrote:
> 
> 
> > The F13 packages *will* work, so long as you're not bisecting back and
> > forth.
> 
> How do I install just the F13 libdrm thing, without changing everything 
> else? I'm willing to try. We can make it part of the 2.6.34 release notes.
> 
> And if we end up having people bisecting back and forth, I will hate that 
> f*cking nouveau driver even more.
> 
> 				Linus

libdrm is composed of the main libdrm, and several driver specific 
libdrms today (... and libkms, yes).

While the main libdrm is relatively stable, the library specific ones 
move all the time, and there is only one version that is being tracked, 
and that is being bumped all the time. The most recent one:

http://cgit.freedesktop.org/mesa/drm/commit/?id=b5495527

Only drivers depend on the driver specific libdrms.

The xserver is compatible all the way to libdrm 2.3.0, which was tagged 
august 2006. xf86-video- drivers might depend on newer driver specific 
libdrms.

And when the mesa tree is taken apart, when drivers are taken out of it, 
you'll find that its real dependency is also 2.3.0. It's the mesa 
drivers that are responsible for the main mesa dependency on libdrm 
2.4.15.

Luc Verhaegen.
