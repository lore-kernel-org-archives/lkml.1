Return-Path: <linux-kernel-owner+w=401wt.eu-S1764511AbZAULd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764511AbZAULd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbZAULdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:33:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:39813 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228AbZAULdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:33:49 -0500
Message-ID: <49770808.2030909@kernel.org>
Date: Wed, 21 Jan 2009 20:33:28 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] x86: Merge hardirq.h
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com> <1232457345-12366-5-git-send-email-brgerst@gmail.com> <4976DA9C.7000500@kernel.org> <20090121101307.GD18728@elte.hu>
In-Reply-To: <20090121101307.GD18728@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 21 Jan 2009 11:33:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Ingo Molnar wrote:
> While this patch was indeed broken, generally for -tip patches we are very 
> permissive and do not require testing 4 .config variants: compile testing 
> on the bit width x86 variant that is being modified is enough. If both 
> variant are modified (as in this case) then compiling the 32-bit and 
> 64-bit defconfig is enough.
> 
> If some build failure slips through it will be handled by automated 
> testing facilities (such as -tip's testing) - it really does not scale if 
> we expect developers to build kernels they dont use (and dont care about 
> nearly as much as about their primary config).
> 
> This lowers the bar of entry to developers who submit their patches from 
> low-powered hardware and simply dont have the means to do wide build 
> testing. The many .config variations are not really the developer's fault 
> but our collective fault. Developers should spend their time thinking 
> about patches, not waiting for the nth kernel build to finish.

I just sent a patch with a lot of compile breakages so I'm feeling
quite embarrassed here but when the patch is touching this low in arch
code, I don't think small four configuration build isn't too much
before sending out a patchset.  With two quad core machines and ram
disk configured, it just doesn't take that much of time (which BTW
doesn't cost that much these days).  With my typical test config,
whole build takes about 80 to 90 seconds.  Four times that is still
under ten minutes.

Anyways, it's a balancing act.  Four small builds don't sound like too
much to me.  Hey, if you're okay with it.  :-)

Thanks.

-- 
tejun
