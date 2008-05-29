Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbYE2LC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbYE2LC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 07:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbYE2LCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 07:02:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34534 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbYE2LCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 07:02:18 -0400
Subject: Re: in-kernel DRM tree move around....
From: David Woodhouse <dwmw2@infradead.org>
To: Dave Airlie <airlied@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.sourceforge.net>
In-Reply-To: <21d7e9970805281746k71b47ed2i79c06288d2dca022@mail.gmail.com>
References: <21d7e9970805281746k71b47ed2i79c06288d2dca022@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 29 May 2008 14:02:15 +0300
Message-Id: <1212058935.26088.11.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 10:46 +1000, Dave Airlie wrote:
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

Looks sane from the header export POV. Passes headers_check and doesn't
add any more instances of CONFIG_xxx visible to userspace (I'm coming
after those, soon).

-- 
dwmw2

