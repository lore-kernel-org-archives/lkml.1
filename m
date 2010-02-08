Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab0BHUBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 15:01:23 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:60334 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab0BHUBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 15:01:21 -0500
Date: Mon, 8 Feb 2010 15:00:44 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Chris Wilson <chris@chris-wilson.co.uk>, tomas m <tmezzadra@gmail.com>
Subject: Re: [Bug #15004] i915: *ERROR* Execbuf while wedged
Message-ID: <20100208200044.GA2677@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	tomas m <tmezzadra@gmail.com>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
 <de962C6zBxL.A.bvE.cFiZLB@chimera>
 <20100205110100.57852c31@jbarnes-piketon>
 <20100205190916.GD2858@think>
 <20100205111747.6619b09b@jbarnes-piketon>
 <20100208172410.GA11311@think>
 <20100208093551.58a10643@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100208093551.58a10643@jbarnes-piketon>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B706D76.00C8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 08, 2010 at 09:35:51AM -0800, Jesse Barnes wrote:
> > 
> > Ok, updating to rc7 and updating my xf86 driver to 2.10 seems to have
> > fixed up my suspend/resume problems.  So, I should be able to trigger
> > the execbuf problem again.
> 
> I've heard some reports that the 2D driver introduces and fixes hangs,
> so it's possible 2.10 will fix both issues for you.
> 
> > Well, the rebooting isn't a huge deal, but if there's something I can
> > track/kick or force to core dump, would it help?
> 
> We do have a test in intel-gpu-tools that will instigate a hang, but it
> would be best to figure out what's causing it in your environment.
> 

[63516.632060] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
[63516.632069] render error detected, EIR: 0x00000000
[63516.632092] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5 (awaiting 2590581 at 2590579)

So, this popped up while surfing in firefox, which is usually where I
hit the execbuf errors.  X was totally stuck afterwards, but I could
switch to a vc and get the dmesg.

If there are specific procs that I can try to get traces of, just let
me know for next time.

-chris

