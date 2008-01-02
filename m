Return-Path: <linux-kernel-owner+w=401wt.eu-S1752679AbYABRwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbYABRwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 12:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYABRwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 12:52:36 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:42980 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752073AbYABRwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 12:52:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HANNde0dMROHU/2dsb2JhbACBV6ZK
Date: Wed, 2 Jan 2008 12:47:29 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, Adrian Bunk <adrian.bunk@movial.fi>,
       Randy Dunlap <randy.dunlap@oracle.com>, phil.el@wanadoo.fr,
       linux-kernel@vger.kernel.org, paulus@samba.org,
       oprofile-list@lists.sourceforge.net
Subject: Re: [2.6.24 patch] Fix Cell OProfile support
Message-ID: <20080102174729.GC2189@Krystal>
References: <20071228185649.GC4738@stusta.de> <20071229160921.GB12262@Krystal> <200712311710.08869.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200712311710.08869.arnd@arndb.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:47:10 up 59 days, 22:52,  5 users,  load average: 1.05, 1.89,
	1.84
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann (arnd@arndb.de) wrote:
> On Saturday 29 December 2007, Mathieu Desnoyers wrote:
> > This patch restores the Cell OProfile support that was killed by
> > commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.
> > 
> > It puts it in arch/powerpc/Kconfig. Since I don't see any good reason to leave
> > this as a supplementary user-selectable option, it is now automatically enabled
> > whenever SPU_FS and OPROFILE are enabled.
> 
> This one has already been superceded by the fix in 
> aed3a8c9bb1a8623a618232087c5ff62718e3b9a, which made CONFIG_OPROFILE_CELL an
> automatically selected option, from arch/powerpc/platforms/cell/Kconfig.
> 

Great, so my patch should be dropped. Thanks!

Mathieu

> 	Arnd <><
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
