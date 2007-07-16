Return-Path: <linux-kernel-owner+w=401wt.eu-S1764780AbXGPAlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764780AbXGPAlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 20:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760811AbXGPAlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 20:41:07 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:57736 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760123AbXGPAlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 20:41:06 -0400
Date: Sun, 15 Jul 2007 20:41:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>
Subject: Re: [patch 4/8] Immediate Value - Add kconfig menus
Message-ID: <20070716004102.GD26411@Krystal>
References: <20070714012439.285079881@polymtl.ca> <20070714012623.839969254@polymtl.ca> <20070714072801.GB5822@martell.zuzino.mipt.ru> <20070714152734.GB4737@Krystal> <20070716003322.GA26835@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070716003322.GA26835@one.firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:38:49 up 8 days, 14:44,  3 users,  load average: 0.11, 0.12, 0.20
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> > On embedded systems, the tradeoff is not the same. The immediate values
> > trade a little bit of system memory (to keep the pointers to the
> > variable and instruction as well as the size of the variable, only used
> > when the variable is updated) in order to remove cache line hot paths.
> 
> Please remove the Kconfig. I don't think it makes sense. Such optimizations
> should be always enabled. We don't have CONFIG_GO_FASTER configs normally.
> Don't introduce them now.
> 
> > 
> > Also, embedded systems with physically read-only memory clearly does not
> > want to enable this.
> 
> We always patch the x86 kernel, so they have to deal with it anyways.
> The x86 port doesn't support XIP.
> 
> -Andi

Hehe, good timing, please see the
immediate-values-kconfig-embedded.patch I just sent. ;) Well, the idea
is to give the option to every architecture in the embedded menu, which
is not limited to X86.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
