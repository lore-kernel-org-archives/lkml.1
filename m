Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbYFAO6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbYFAO6L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYFAO56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:57:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1699 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751434AbYFAO55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:57:57 -0400
Date: Sun, 1 Jun 2008 16:57:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dave Airlie <airlied@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.sourceforge.net>
Subject: Re: in-kernel DRM tree move around....
Message-ID: <20080601145750.GA4652@ucw.cz>
References: <21d7e9970805281746k71b47ed2i79c06288d2dca022@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970805281746k71b47ed2i79c06288d2dca022@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-05-29 10:46:22, Dave Airlie wrote:
> Hi,
> 
> So I've been growing more annoyed with the current layout of the drm
> tree in the kernel,
> 
> a) it lives under char.
> b) everything in one directory.
> c) header files in one directory.
> d) no header files exposed to userspace.
> 
> http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commitdiff;h=7df9a948d0f849466e3de259cccb49bc54cbad68
> 
> is a proposal to create drivers/gpu/drm, (I may move AGP in there as
> well later). It also creates per-driver subdirs.

I'm unsure about agp... drivers/char/agp/*amd64* seems to contain gart/iommu
stuff that is shared by whole kernel...

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
