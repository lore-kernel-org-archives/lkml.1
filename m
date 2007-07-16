Return-Path: <linux-kernel-owner+w=401wt.eu-S1764139AbXGPAGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764139AbXGPAGi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 20:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762190AbXGPAG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 20:06:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50270 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757887AbXGPAG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 20:06:26 -0400
Date: Sun, 15 Jul 2007 17:05:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
Subject: Re: [git pull] DRM tree for 2.6.23-rc1
In-Reply-To: <Pine.LNX.4.64.0707160059330.25885@skynet.skynet.ie>
Message-ID: <alpine.LFD.0.999.0707151704300.20061@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0707160059330.25885@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-2022-jp
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 16 Jul 2007, Dave Airlie wrote:
> 
> Please pull the 'drm-patches' branch from the drm git tree.
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
> drm-patches

This totally breaks for me.

	  CC      drivers/char/drm/drm_ioc32.o
	drivers/char/drm/drm_ioc32.c: In function ‘compat_drm_version’:
	drivers/char/drm/drm_ioc32.c:85: error: ‘drm_version_t’ undeclared (first use in this function)
	drivers/char/drm/drm_ioc32.c:85: error: (Each undeclared identifier is reported only once
	..

followed by hundreds of lines of warnings.

		Linus
