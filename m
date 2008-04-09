Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbYDIP0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbYDIP0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 11:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYDIP0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 11:26:34 -0400
Received: from outbound-mail-110.bluehost.com ([69.89.22.10]:53455 "HELO
	outbound-mail-110.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752689AbYDIP0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:26:33 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Justin Madru <jdm64@gawab.com>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
Date: Wed, 9 Apr 2008 08:24:35 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>
References: <47D828BB.2000702@gawab.com> <200804011322.58259.jbarnes@virtuousgeek.org> <47FC4C9B.1030703@gawab.com>
In-Reply-To: <47FC4C9B.1030703@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804090824.35825.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 08, 2008 9:56 pm Justin Madru wrote:
> Jesse Barnes wrote:
> > Yeah, seems pretty weird.  Given that you see it w/o the fb stuff loaded
> > as well and we still have a few open bugs against the intel X driver
> > regarding VT switch & mode programming, I don't think this is a real
> > kernel regression. It's more likely that some timing or memory layout
> > changed subtly and is causing to to hit one of our existing bugs more
> > frequently that you did before.  Can you file a bug against the intel X
> > driver at
> > bugs.freedesktop.org so we can track it there?  Unless we can find a way
> > to reproduce it reliably it'll probably take a long time to fix, but we
> > don't want to lose it either...
>
> Well, I'll file a bug on bugs.freedesktop.org, but if you don't think
> it's a kernel regression then I'll wait until the final release of
> 2.6.25 comes out (unless you _really_ need me to file it sooner).

Well, given what we've tested so far, it really doesn't seem like a 
framebuffer layer regression nor a DRM regression... I suppose you could try 
bisecting, but given that the problem doesn't happen everytime that might 
take awhile...

> This is what I have in my config:
> > CONFIG_PREEMPT_RCU=y
> > CONFIG_IO_DELAY_NONE=y
>
> By the way is the intel driver that you work on the same that's enabled by:
> > CONFIG_AGP_INTEL=m
> > CONFIG_DRM_I915=m
>
> Or is there another X.org intel driver? And if so how are they
> (agp/drm/X.org) related?

You could try using the X vesa driver instead of the intel driver...

Jesse
