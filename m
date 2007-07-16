Return-Path: <linux-kernel-owner+w=401wt.eu-S1763102AbXGPAaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763102AbXGPAaI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 20:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757919AbXGPA34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 20:29:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:40539 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975AbXGPA3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 20:29:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AbfBu7b/T7oqlhZhLZAOXc+REruHh9v/cIEto0LFq4xfx8CPp5ob/sAm7r3DG6/N30tRg8zTfQMl29nEwvz5614TfCioQS6D9kkWNt2bZ+WMBMajdIOOP0isLgfixN1h3TubBHWtOhPqczh8rFI/QHv8gJhYNVsioys8QjWb+gY=
Message-ID: <21d7e9970707151729t330e08eeo559f95349543b41a@mail.gmail.com>
Date: Mon, 16 Jul 2007 10:29:53 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [git pull] DRM tree for 2.6.23-rc1
Cc: "Dave Airlie" <airlied@linux.ie>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
In-Reply-To: <alpine.LFD.0.999.0707151704300.20061@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0707160059330.25885@skynet.skynet.ie>
	 <alpine.LFD.0.999.0707151704300.20061@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Mon, 16 Jul 2007, Dave Airlie wrote:
> >
> > Please pull the 'drm-patches' branch from the drm git tree.
> > ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
> > drm-patches
>
> This totally breaks for me.
>
>           CC      drivers/char/drm/drm_ioc32.o
>         drivers/char/drm/drm_ioc32.c: In function 'compat_drm_version':
>         drivers/char/drm/drm_ioc32.c:85: error: 'drm_version_t' undeclared (first use in this function)
>         drivers/char/drm/drm_ioc32.c:85: error: (Each undeclared identifier is reported only once
>         ..
>
> followed by hundreds of lines of warnings.

Damn, you had to pick the week I've only got my 32-bit laptop
connected to open the merge window :-), I thought it might have hit an
-mm but there doesn't seem to be any during the merge window...

I'll get some cross compilers down and try and squeeze them onto it..

drop it and I'll fix it up and resend...

Dave.
