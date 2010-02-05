Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab0BEJAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 04:00:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33305 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab0BEJAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 04:00:33 -0500
Date: Fri, 5 Feb 2010 10:00:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@linux.ie>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, dri-devel@lists.sf.net,
       Alex Deucher <alexdeucher@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch
 out of staging."
Message-ID: <20100205090009.GA8272@elte.hu>
References: <20100204190649.GB6665@elte.hu>
 <a728f9f91002041118m6415844fp1740f18fdc1c9757@mail.gmail.com>
 <20100204193232.GD6665@elte.hu>
 <20100204115316.69beee75@jbarnes-piketon>
 <20100204202254.GA24716@elte.hu>
 <20100204204829.GA24608@srcf.ucam.org>
 <20100204210559.GC19050@elte.hu>
 <20100204210950.GA25295@srcf.ucam.org>
 <20100205075645.GF9320@elte.hu>
 <alpine.DEB.2.00.1002050832450.2995@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002050832450.2995@skynet.skynet.ie>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Airlie <airlied@linux.ie> wrote:

> 
> > If it now does not boot up if all its sub-options are enabled, even of some 
> > of those sub-options are new, does that count as a driver regression? Sure it 
> > does to me ...
> 
> But it doesn't to anyone else under any reasonable meaning of the word 
> regression.

There are reactions in this thread that contradict your 'anyone else' point.

> The config option states
> "Choose this option if you want kernel modesetting enabled by default,
>           and you have a new enough userspace to support this. Running old
>           userspaces with this enabled will cause pain."
> 
> Will cause pain sounds painful to me, I can make it seem much worse if 
> you'd like.

Except you are missing that the hang (and the first crash as well) happens on 
brand-new user-space just as much - not just on 'old userspaces'.

The bugs i've triggered are independent of any user-space component - it 
happens with a fresh distro just as much.

As i suggested before, at least the text should be updated to include what 
has been written about CONFIG_DRM_RADEON_KMS in this thread before:

 > This is a completely new driver.  It's only part of the existing drm for 
 > compatibility reasons.  It requires an entirely different graphics stack 
 > above it and works very differently from the old drm stack.

Thanks,

	Ingo
