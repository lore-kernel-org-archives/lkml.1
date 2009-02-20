Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbZBTIxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbZBTIxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 03:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZBTIxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 03:53:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34906
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752218AbZBTIxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 03:53:16 -0500
Date: Fri, 20 Feb 2009 00:52:58 -0800 (PST)
Message-Id: <20090220.005258.259993381.davem@davemloft.net>
To: arnd@arndb.de
Cc: airlied@linux.ie, benh@kernel.crashing.org,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: Only use DRM_IOCTL_UPDATE_DRAW compat wrapper for
 compat X86.
From: David Miller <davem@davemloft.net>
In-Reply-To: <200902191519.03399.arnd@arndb.de>
References: <20090218.013521.97380943.davem@davemloft.net>
	<200902191519.03399.arnd@arndb.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 19 Feb 2009 15:19:01 +0100

> On Wednesday 18 February 2009, David Miller wrote:
> > drm: Only use DRM_IOCTL_UPDATE_DRAW compat wrapper for compat X86.
> > 
> > Only X86 32-bit uses a different alignment for "unsigned long long"
> > than it's 64-bit counterpart.
> > 
> > Therefore this compat translation is only correct, and only needed,
> > when either CONFIG_X86 or CONFIG_IA64.
> > 
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> The patch is correct AFAICT, but I'd like to point out that the
> problem could have been avoided (besides using a non-padded layout)
> by using a compat_u64 member in the struct definition instead of
> the packed attribute:

Indeed, David A. showed me compat_u64 et al. and I'm fine with
it being fixed that way too.  Feel free to submit a patch :)
