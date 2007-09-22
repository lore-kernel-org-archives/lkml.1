Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbXIVOlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbXIVOlA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 10:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbXIVOky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 10:40:54 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:59893 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495AbXIVOkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 10:40:53 -0400
Date: Sat, 22 Sep 2007 10:35:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Paul Mackerras <paulus@samba.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [patch 04/28] Add cmpxchg64 and cmpxchg64_local to powerpc
Message-ID: <20070922143540.GA12865@Krystal>
References: <20070827155234.062715780@polymtl.ca> <20070827155524.827591009@polymtl.ca> <18164.40462.991761.909735@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <18164.40462.991761.909735@cargo.ozlabs.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:34:09 up 54 days, 14:53,  2 users,  load average: 0.63, 0.80, 0.52
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Mackerras (paulus@samba.org) wrote:
> Mathieu Desnoyers writes:
> 
> > Make sure that at least cmpxchg64_local is available on all architectures to use
> > for unsigned long long values.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> Acked-by: Paul Mackerras <paulus@samba.org>

Thanks Paul,

Just make sure add-cmpxchg-local-to-generic-for-up.patch gets merged
before this one, since it needs asm-generic/cmpxchg-local.h.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
