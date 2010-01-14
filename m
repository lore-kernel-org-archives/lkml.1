Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196Ab0ANAzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab0ANAzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 19:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043Ab0ANAzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 19:55:35 -0500
Received: from outbound-mail-139.bluehost.com ([67.222.39.29]:44723 "HELO
	outbound-mail-139.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751885Ab0ANAze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 19:55:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=doxccCcGO0Is4sJe3REcu/r5nF6BpFQRkYhUhRTPPexZFsA+fw0x7I4eSogvtGuW/tXQYulvCxPf77uBtd/IevivNG7K0dz45mFjgRTGxoAEtQtGIjNPi74+1OVEDM4W;
Date: Wed, 13 Jan 2010 16:55:30 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       airlied@linux.ie
Subject: Re: Linux 2.6.33-rc4
Message-ID: <20100113165530.2a7e7645@jbarnes-piketon>
In-Reply-To: <4B4E403C.1050509@cs.helsinki.fi>
References: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain>
	<84144f021001131303u56fa5470ua1c27dfef9f3de81@mail.gmail.com>
	<20100113133357.67f9df6d@jbarnes-piketon>
	<4B4E403C.1050509@cs.helsinki.fi>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010 23:50:52 +0200
Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Jesse Barnes wrote:
> > On Wed, 13 Jan 2010 23:03:00 +0200
> > Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > 
> >> On Wed, Jan 13, 2010 at 7:44 AM, Linus Torvalds
> >> <torvalds@linux-foundation.org> wrote:
> >>> Hmm. Odd release. Something like 40% of the patches are in DRM
> >>> (mostly nouveau and radeon, both staging, so it's a bit less scary
> >>> than it sounds. But there's a noticeable i915 component too).
> >>> That's all pretty unusual, afaik.
> >> 2.6.33-rc4 still suffers from an annoying screen flicker with i915
> >> and KMS on my machine. I *think* it started with 2.6.33-rc1 but I
> >> haven't had the time to dig deeper.
> > 
> > Does this patch fix it?  If so I'll queue something like this up for
> > -rc5.
> 
> Yes, it does. Thanks!

Great, thanks for testing.  I'll send Eric a patch to disable this
feature more properly.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
